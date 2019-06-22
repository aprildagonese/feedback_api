defmodule FeedbackApiWeb.SurveyCreateFacade do
  alias FeedbackApi.{Survey, User, Question, Group, Repo}
  import Ecto.Query

  def create_survey(arguments, user) do
    Repo.transaction(fn ->
      try do
        survey =
          # Ecto.build_assoc(user, :surveys, %Survey{
          #   name: arguments["surveyName"],
          #   status: parse_status(arguments["status"]),
          #   exp_date: parseDateTime(arguments["surveyExpiration"])
          # })
          # |> Repo.insert!()

          %Survey{
            name: arguments["surveyName"],
            status: parse_status(arguments["status"]),
            exp_date: parseDateTime(arguments["surveyExpiration"])
          }
          |> Repo.insert!()
          |> Repo.preload(:owners)
          |> Ecto.Changeset.change()
          |> Ecto.Changeset.put_assoc(:owners, [user])
          |> Repo.update!()

        create_groups(survey, arguments["groups"])
        create_questions(survey, arguments["questions"])
        FeedbackApi.SurveyNotificationSupervisor.send_notifications(survey)
      rescue
        _e -> Repo.rollback("Missing required fields")
      end
    end)
  end

  defp create_groups(survey, groups) do
    Enum.map(groups, fn group -> create_group(survey, group) end)
  end

  defp create_questions(survey, questions) do
    Enum.map(questions, fn question -> create_question(survey, question) end)
  end

  defp create_group(survey, group) do
    new_group =
      Group.changeset(%Group{}, group) |> Repo.insert!() |> Repo.preload([:survey, :users])

    users = Repo.all(from u in User, where: u.id in ^group["members_ids"])

    group_associations_changeset =
      Ecto.Changeset.change(new_group)
      |> Ecto.Changeset.put_assoc(:survey, survey)
      |> Ecto.Changeset.put_assoc(:users, users)

    Repo.update!(group_associations_changeset)
  end

  defp create_question(survey, question) do
    new_question =
      Question.changeset(%Question{}, %{text: question["questionTitle"]})
      |> Repo.insert!()
      |> Repo.preload([:survey, :answers])

    create_answers(new_question, question["options"])

    Ecto.Changeset.change(new_question)
    |> Ecto.Changeset.put_assoc(:survey, survey)
    |> Repo.update!()
  end

  defp create_answers(question, answers) do
    Enum.map(answers, fn answer -> create_answer(question, answer) end)
  end

  defp create_answer(question, nested_answer) do
    # Answer is received as nested object, grab values for actual answer
    answer = hd(Map.values(nested_answer))

    new_answer =
      Ecto.build_assoc(question, :answers, %{
        description: answer["description"],
        value: answer["pointValue"]
      })

    Repo.insert!(new_answer)
  end

  defp parseDateTime(time) do
    case time do
      nil ->
        nil

      time ->
        NaiveDateTime.from_iso8601!(time)
        |> NaiveDateTime.truncate(:second)
    end
  end

  def parse_status(status) do
    case status do
      nil -> "Active"
      status -> String.capitalize(status)
    end
  end
end
