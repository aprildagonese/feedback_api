defmodule FeedbackApiWeb.SurveysController do
  use FeedbackApiWeb, :controller
  alias FeedbackApi.{Survey, Repo}
  alias FeedbackApiWeb.SurveyCreateFacade
  import Ecto.Query

  def index(conn, _params) do
    surveys =
      Repo.all(
        from survey in Survey,
          left_join: groups in assoc(survey, :groups),
          left_join: users in assoc(groups, :users),
          left_join: questions in assoc(survey, :questions),
          left_join: answers in assoc(questions, :answers),
          order_by: [desc: survey.inserted_at, desc: answers.value],
          preload: [groups: {groups, users: users}, questions: {questions, answers: answers}]
      )

    render(conn, "index.json", surveys: surveys)
  end

  def create(conn, params) do
    case SurveyCreateFacade.create_survey(params) do
      {:ok, _survey} -> conn |> put_status(:created) |> json(%{success: "Survey stored"})
      {:error, error} -> conn |> put_status(:unprocessable_entity) |> json(%{error: error})
    end
  end
end
