defmodule FeedbackApiWeb.UsersController do
  use FeedbackApiWeb, :controller
  alias FeedbackApi.{User, Repo}
  alias FeedbackApiWeb.UsersUpdateFacade

  def create(conn, _params) do
    case UsersUpdateFacade.update_student_data do
      {:ok, _users} -> conn |> put_status(:created) |> json(%{success: "Data refreshed"})
      {:error, error} -> conn |> put_status(:request_timeout) |> json(%{error: error})
    end
  end

  def index(conn, _params) do
    users = User.all_with_cohort()
    render(conn, "index.json", users: users)
  end
end