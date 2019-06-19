defmodule FeedbackApiWeb.Surveys.HistoryController do
  use FeedbackApiWeb, :controller
  alias FeedbackApi.{User, Survey}

  def index(conn, params) do
    case User.authorize_student(params["api_key"]) do
      nil -> conn |> put_status(:unauthorized) |> json(%{error: "Invalid API Key"})
      user -> conn |> render("index.json", %{surveys: Survey.for_participant(user)})
    end
  end
end
