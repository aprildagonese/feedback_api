defmodule FeedbackApiWeb.SurveysView do
  use FeedbackApiWeb, :view
  alias FeedbackApiWeb.{SurveysView, QuestionView, GroupView}

  def render("index.json", %{surveys: surveys}) do
    render_many(surveys, SurveysView, "survey.json")
  end

  def render("show.json", %{survey: survey}) do
    render_one(survey, SurveysView, "survey.json")
  end

  def render("survey.json", %{surveys: survey}) do
    %{
      id: survey.id,
      name: survey.name,
      status: survey.status,
      created_at: survey.inserted_at,
      updated_at: survey.updated_at,
      questions: render_many(survey.questions, QuestionView, "question.json"),
      groups: render_many(survey.groups, GroupView, "group.json")
    }
  end
end
