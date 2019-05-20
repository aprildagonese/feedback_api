defmodule FeedbackApiWeb.GroupView do
  use FeedbackApiWeb, :view
  alias FeedbackApiWeb.GroupView

  def render("index.json", %{groups: groups}) do
    render_many(groups, GroupView, "group.json")
  end

  def render("show.json", %{group: group}) do
    render_one(group, GroupView, "group.json")
  end

  def render("group.json", %{group: group}) do
    %{name: group.name, member_ids: Enum.map(group.users, fn user -> user.id end)}
  end
end
