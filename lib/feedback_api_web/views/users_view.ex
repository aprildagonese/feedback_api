defmodule FeedbackApiWeb.UsersView do
  use FeedbackApiWeb, :view
  alias FeedbackApiWeb.UsersView

  def render("index.json", %{users: users}) do
    render_many(users, UsersView, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, UsersView, "user.json")
  end

  def render("user.json", %{user: user}) do
    %{id: user, name: user}
  end
end
