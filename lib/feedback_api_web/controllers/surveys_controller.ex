defmodule FeedbackApiWeb.SurveysController do
  use FeedbackApiWeb, :controller
  alias FeedbackApi.{Survey, Repo}

  def index(conn, _params) do
    surveys = Survey |> Repo.all

    render(conn, "index.json", surveys: surveys)
  end

  def create(conn, params) do
    survey = Survey.changeset(%Survey{}, params)
    case Repo.insert(survey) do
      {:ok, survey} -> render(conn, "show.json", survey: survey)
      {:error, survey} -> json(conn, survey.errors)
    end
  end
end
