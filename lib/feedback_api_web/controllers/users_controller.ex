defmodule FeedbackApiWeb.UsersController do
  use FeedbackApiWeb, :controller
  alias FeedbackApi.{User, Repo}
  alias FeedbackApiWeb.UsersUpdateFacade
  import Ecto.Query

  def create(conn, _params) do
    case UsersUpdateFacade.update_data() do
      {:ok, _users} -> conn |> put_status(:created) |> json(%{success: "Data refreshed"})
      {:error, error} -> conn |> put_status(:request_timeout) |> json(%{error: error})
    end
  end

  def index(conn, params) do
    users =
      case params do
        %{"cohort" => cohort, "program" => program} ->
          User.by_program_and_cohort(program, cohort)

        %{"cohort" => cohort} ->
          User.by_cohort(cohort)

        %{"program" => program} ->
          User.by_program(program)

        %{} ->
          User.active_students
      end

    render(conn, "index.json", users: users)
  end
end
