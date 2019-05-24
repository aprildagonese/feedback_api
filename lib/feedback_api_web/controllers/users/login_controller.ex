defmodule FeedbackApiWeb.Users.LoginController do
  use FeedbackApiWeb, :controller
  alias FeedbackApi.{User, Repo}
  import Ecto.Query

  def create(conn, params) do
    user = Repo.get_by(User, email: params["email"])
    hash = user.password
    result = Bcrypt.verify_pass(params["password"], hash)
  
    case result do
      true -> render(conn, "login_user.json", users: user)
      false -> conn |> put_status(:unauthorized) |> json(%{error: "Invalid credentials"})
    end
  end
end
