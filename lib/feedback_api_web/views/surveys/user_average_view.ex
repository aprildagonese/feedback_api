defmodule FeedbackApiWeb.Surveys.UserAverageView do
  use FeedbackApiWeb, :view
  alias FeedbackApiWeb.{Surveys.UserAverageView, SurveyView}

  def render("show.json", %{average: average}) do
    render_one(average, UserAverageView, "user_average.json")
  end

  def render("user_average.json", %{user_average: user_average}) do
    %{
      survey: render_one(user_average.survey, SurveyView, "survey.json"),
      averages:
        Enum.map(user_average.average, fn user ->
          %{
            user_id: user.user_id,
            question_id: user.question_id,
            fullName: user.user_name,
            average_rating: user.average_rating
          }
        end)
    }
  end
end
