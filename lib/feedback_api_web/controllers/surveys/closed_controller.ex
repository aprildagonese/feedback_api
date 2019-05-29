defmodule FeedbackApiWeb.Surveys.ClosedController do
  use FeedbackApiWeb, :controller
  alias FeedbackApi.{User, Survey}

  def index(conn, params) do
    case User.authorize(params["api_key"]) do
      nil -> conn |> put_status(:unauthorized) |> json(%{error: "Invalid API Key"})
      user -> conn |> render("index.json", Survey.closed_for_user(user))
    end
  end
end
