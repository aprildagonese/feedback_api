defmodule FeedbackApiWeb.SurveyCreateFacade do
  alias FeedbackApi.{Survey, Question, Group, Answer, Repo}

  def create_survey(params, user) do
    Survey.create_from_request(params, user)
    |> create_groups(params["groups"])
    |> create_questions(params["questions"])
    |> Repo.insert()
  end

  defp create_groups(survey, groups) do
    Enum.reduce(groups, survey, fn group, survey -> Group.create_for_survey(survey, group) end)
  end

  defp create_questions(survey, questions) do
    Enum.reduce(questions, survey, fn question, survey ->
      Question.create_for_survey(survey, question, create_answers(question["options"]))
    end)
  end

  defp create_answers(answers) do
    Enum.map(answers, fn answer -> Answer.create_from_request(answer) end)
  end
end
