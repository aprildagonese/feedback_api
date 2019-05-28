defmodule FeedbackApiWeb.Surveys.AverageController do
  use FeedbackApiWeb, :controller
  alias FeedbackApi.Survey

  def show(conn, params) do
    averages = Survey.averages(params["survey_id"])
    survey = Survey.one(params["survey_id"])
    response = %{averages: averages, survey: survey}

    render(conn, "show.json", %{average: response})
  end
end
