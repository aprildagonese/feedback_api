defmodule FeedbackApiWeb.Surveys.UserAverageView do
  use FeedbackApiWeb, :view
  alias FeedbackApiWeb.{QuestionView, Surveys.UserAverageView}

  def render("show.json", %{average: average}) do
    render_one(average, UserAverageView, "user_average.json")
  end

  def render("user_average.json", %{user_average: user_average}) do
    %{
      
    }
  end
end
