defmodule FeedbackApiWeb.Users.RegisterController do
  use FeedbackApiWeb, :controller
  alias FeedbackApi.{User, Repo}
  import Ecto.Query

  def create(conn, params) do
    result =
      case Repo.get_by(User, name: params["fullName"]) do
        nil -> %User{}
        user -> Ecto.Changeset.change(user)
      end
      |> User.changeset(%{
        email: params["email"],
        role: params["role"],
        password: Bcrypt.hash_pwd_salt(params["password"]),
        api_key: Ecto.UUID.generate(),
        name: params["fullName"],
        status: "Active"
      })
      |> Repo.insert_or_update()

    case result do
      {:ok, user} ->
        FeedbackApi.WelcomeNotificationSupervisor.send_notification(user)
        render(conn, "register_user.json", users: user)

      {:error, error} ->
        conn |> put_status(:request_timeout) |> json(%{error: error})
    end
  end
end
