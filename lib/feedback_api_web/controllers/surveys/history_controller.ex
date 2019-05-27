defmodule FeedbackApiWeb.Surveys.HistoryController do
  use FeedbackApiWeb, :controller

  def index(conn, params) do
    case User.authorize(params["api_key"]) do
      nil -> conn |> put_status(:unauthorized) |> json(%{error: "Invalid API Key"})
      user -> conn |> render("index.json", Survey.for_participant(user))
    end
  end
end
