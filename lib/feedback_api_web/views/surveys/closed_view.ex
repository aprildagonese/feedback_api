defmodule FeedbackApiWeb.Surveys.ClosedView do
  use FeedbackApiWeb, :view
  alias FeedbackApiWeb.SurveyView

  def render("index.json", %{surveys: surveys}) do
    render_many(surveys, SurveyView, "survey.json")
  end
end
