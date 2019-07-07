defmodule FeedbackApiWeb.Api.V2.Staff.InstructorView do
  use FeedbackApiWeb, :view

  alias FeedbackApiWeb.Api.V2.Staff.InstructorView

  def render("index.json", %{instructors: instructors}) do
    render_many(instructors, InstructorView, "instructor.json")
  end

  def render("instructor.json", %{instructor: instructor}) do
    %{
      id: instructor.id,
      name: instructor.name
    }
  end
end
