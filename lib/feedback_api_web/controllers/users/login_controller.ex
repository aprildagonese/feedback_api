defmodule FeedbackApiWeb.Users.LoginController do
  use FeedbackApiWeb, :controller
  alias FeedbackApi.{User, Repo}
  import Ecto.Query

  def create(conn, params) do
    user = Repo.get_by(User, email: params["email"])
    hash = user.password
    result = Bcrypt.verify_pass(params["password"], hash)
    IO.inspect(user)
    IO.inspect(hash)
    IO.inspect(result)
    # render(conn, "login_user.json", user: user)
    # hash = Bcrypt.hash_pwd_salt("password")
  end
end
