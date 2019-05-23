defmodule FeedbackApiWeb.Surveys.AverageView do
  use FeedbackApiWeb, :view
  alias FeedbackApiWeb.{QuestionView, Surveys.AverageView}

  def render("show.json", %{average: average}) do
    render_one(average, AverageView, "average.json")
  end

  def render("average.json", %{average: average}) do
    %{
      id: average.survey.id,
      name: average.survey.name,
      status: average.survey.status,
      exp_date: average.survey.exp_date,
      created_at: average.survey.inserted_at,
      updated_at: average.survey.updated_at,
      questions: render_many(average.survey.questions, QuestionView, "question.json"),
      averages:
        Enum.map(average.averages, fn average ->
          %{
            question_id: average.id,
            text: average.text,
            average_rating: average.average
          }
        end)
    }
  end
end
