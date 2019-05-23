defmodule FeedbackApiWeb.Surveys.AverageView do
  use FeedbackApiWeb, :view
  alias FeedbackApiWeb.{SurveyView, Surveys.AverageView}

  def render("show.json", %{average: average}) do
    render_one(average, AverageView, "average.json")
  end

  def render("average.json", %{average: average}) do
    %{
      survey: render_one(average.survey, SurveyView, "survey.json"),
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
