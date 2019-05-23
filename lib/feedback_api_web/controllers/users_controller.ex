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
          Repo.all(
            from u in User,
              join: cohorts in assoc(u, :cohort),
              where: cohorts.name == ^cohort,
              where: u.program == ^String.upcase(program),
              preload: [cohort: cohorts]
          )

        %{"cohort" => cohort} ->
          Repo.all(
            from u in User,
              join: cohorts in assoc(u, :cohort),
              where: cohorts.name == ^cohort,
              preload: [cohort: cohorts]
          )

        %{"program" => program} ->
          Repo.all(
            from u in User,
              join: cohorts in assoc(u, :cohort),
              where: u.program == ^String.upcase(program),
              preload: [cohort: cohorts]
          )

        %{} ->
          Repo.all(
            from u in User,
              join: cohorts in assoc(u, :cohort),
              preload: [cohort: cohorts]
          )
      end

    render(conn, "index.json", users: users)
  end
end
