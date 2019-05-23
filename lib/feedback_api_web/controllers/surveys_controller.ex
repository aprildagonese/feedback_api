defmodule FeedbackApiWeb.SurveyController do
  use FeedbackApiWeb, :controller
  alias FeedbackApi.{Survey, Repo}
  alias FeedbackApiWeb.SurveyCreateFacade
  import Ecto.Query

  def index(conn, _params) do
    surveys = Survey.all()

    render(conn, "index.json", surveys: surveys)
  end

  def create(conn, params) do
    case SurveyCreateFacade.create_survey(params["survey"]) do
      {:ok, _survey} -> conn |> put_status(:created) |> json(%{success: "Survey stored"})
      {:error, error} -> conn |> put_status(:unprocessable_entity) |> json(%{error: error})
    end
  end
end
