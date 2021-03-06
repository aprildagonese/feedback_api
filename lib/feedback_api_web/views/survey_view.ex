defmodule FeedbackApiWeb.SurveyView do
  use FeedbackApiWeb, :view
  alias FeedbackApiWeb.{SurveyView, QuestionView, GroupView}

  def render("index.json", %{surveys: surveys}) do
    render_many(surveys, SurveyView, "survey.json")
  end

  def render("show.json", %{survey: survey}) do
    render_one(survey, SurveyView, "survey.json")
  end

  def render("survey.json", %{survey: survey}) do
    %{
      id: survey.id,
      surveyName: survey.name,
      status: survey.status,
      surveyExpiration: survey.exp_date,
      created_at: survey.inserted_at,
      updated_at: survey.updated_at,
      questions: render_many(survey.questions, QuestionView, "question.json"),
      groups: render_many(survey.groups, GroupView, "group.json")
    }
  end
end
