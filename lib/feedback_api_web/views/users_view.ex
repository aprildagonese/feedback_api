defmodule FeedbackApiWeb.UsersView do
  use FeedbackApiWeb, :view
  alias FeedbackApiWeb.UsersView

  def render("index.json", %{users: users}) do
    render_many(users, UsersView, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, UsersView, "user.json")
  end

  def render("user.json", %{users: user}) do
    %{id: user.id, name: user.name, program: user.program, cohort: user.cohort.name}
  end
end
