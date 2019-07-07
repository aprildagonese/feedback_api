defmodule FeedbackApiWeb.Api.V2.Staff.InstructorController do
  use FeedbackApiWeb, :controller

  alias FeedbackApi.User

  def index(conn, %{"api_key" => api_key}) do
    case User.authorize_instructor(api_key) do
      nil -> conn |> put_status(:unauthorized) |> json(%{error: "Invalid API Key"})
      user -> conn |> render("index.json", %{instructors: User.active_instructors(user)})
    end
  end

  def index(conn, _params) do
    conn |> put_status(:unauthorized) |> json(%{error: "Invalid API Key"})
  end
end
