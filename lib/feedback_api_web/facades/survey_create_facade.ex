defmodule FeedbackApiWeb.SurveyCreateFacade do
  alias FeedbackApi.{Survey, User, Question, Group, Repo}
  import Ecto.Query

  def create_survey(arguments) do
    Repo.transaction(fn ->
      try do
        survey = Survey.changeset(%Survey{}, arguments) |> Repo.insert!()
        create_groups(survey, arguments["groups"])
        create_questions(survey, arguments["questions"])
      rescue
        _e -> Repo.rollback("Missing required fields")
      end
    end)
  end

  defp create_groups(survey, groups) do
    IO.inspect(groups)
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
      Question.changeset(%Question{}, question)
      |> Repo.insert!()
      |> Repo.preload([:survey, :answers])

    create_answers(new_question, question["answers"])

    Ecto.Changeset.change(new_question)
    |> Ecto.Changeset.put_assoc(:survey, survey)
    |> Repo.update!()
  end

  defp create_answers(question, answers) do
    Enum.map(answers, fn answer -> create_answer(question, answer) end)
  end

  defp create_answer(question, answer) do
    new_answer =
      Ecto.build_assoc(question, :answers, %{
        description: answer["description"],
        value: answer["value"]
      })

    Repo.insert!(new_answer)
  end
end
