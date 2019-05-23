defmodule FeedbackApiWeb.Users.RegisterController do
  use FeedbackApiWeb, :controller
  alias FeedbackApi.{User, Repo}
  import Ecto.Query

  def create(conn, params) do
    if params["role"] == "Student" do
      user = Repo.get_by(User, name: params["fullName"])
      IO.inspect(params)
      render(conn, "register_user.json", users: user)
    else
    end
    # user = Repo.get_by(User, [email: params["email"], password: params["password"]])
    # render(conn, "register_user.json", user: user)
    # hash = Bcrypt.hash_pwd_salt("password")
  end
end
