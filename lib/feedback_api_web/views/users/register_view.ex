defmodule FeedbackApiWeb.Users.RegisterView do
  use FeedbackApiWeb, :view

  def render("register_user.json", %{users: user}) do
    %{
      "id": user.id,
      "api_key": user.api_key,
      "role": user.role,
      "full_name": user.name
     }
  end
end
