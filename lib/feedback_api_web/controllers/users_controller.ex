defmodule FeedbackApiWeb.UsersController do
  use FeedbackApiWeb, :controller
  alias FeedbackApi.{User, Repo}

  def create(conn, _params) do
    # users = User.changeset(%User{}, params)

    # case Repo.insert(users) do
    #   {:ok, users} -> render(conn, "index.json", users: users)
    #   {:error, users} -> json(conn, users.errors)
    # end
  end

  def index(conn, %{"name" => name}) do
    # users = User |> Repo.all()
    json(conn, %{name: name})
    # render(conn, "index.json", users: users)
  end
end
