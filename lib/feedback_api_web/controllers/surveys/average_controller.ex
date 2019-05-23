defmodule FeedbackApiWeb.Surveys.AverageController do
  use FeedbackApiWeb, :controller
  alias FeedbackApi.Survey

  def show(conn, params) do
    average = Survey.averages(params["survey_id"])

    render(conn, "show.json", %{average: average})
  end
end
