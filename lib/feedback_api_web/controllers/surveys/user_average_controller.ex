defmodule FeedbackApiWeb.Surveys.UserAverageController do
  use FeedbackApiWeb, :controller
  alias FeedbackApi.Survey

  def show(conn, params) do
    average = Survey.user_averages(params["survey_id"])
    survey = Survey.one(params["survey_id"])
    data = %{average: average, survey: survey}

    render(conn, "show.json", %{average: data})
  end
end
