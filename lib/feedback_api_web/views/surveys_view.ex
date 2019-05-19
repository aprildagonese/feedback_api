defmodule FeedbackApiWeb.SurveysView do
  use FeedbackApiWeb, :view
  alias FeedbackApiWeb.SurveysView

  def render("index.json", %{surveys: surveys}) do
    render_many(surveys, SurveysView, "survey.json")
  end

  def render("show.json", %{survey: survey}) do
    render_one(survey, SurveysView, "survey.json")
  end

  def render("survey.json", %{surveys: survey}) do
    %{id: survey.id, name: survey.name}
  end
end
