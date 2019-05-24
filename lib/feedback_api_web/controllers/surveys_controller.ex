defmodule FeedbackApiWeb.SurveyController do
  use FeedbackApiWeb, :controller
  alias FeedbackApi.{Survey, Repo, User}
  alias FeedbackApiWeb.SurveyCreateFacade
  import Ecto.Query

  def index(conn, params) do
    case User.authorize(params["api_key"]) do
      nil -> conn |> put_status(:unauthorized) |> json(%{error: "Invalid API Key"})
      user -> conn |> render("index.json", %{surveys: Survey.for_user(user)})
    end
  end

  def create(conn, params) do
    case User.authorize(params["api_key"]) do
      nil -> conn |> put_status(:unauthorized) |> json(%{error: "Invalid API Key"})
      user -> case SurveyCreateFacade.create_survey(params["survey"], user) do
        {:ok, _survey} -> conn |> put_status(:created) |> json(%{success: "Survey stored"})
        {:error, error} -> conn |> put_status(:unprocessable_entity) |> json(%{error: error})
      end
    end

  end
end
