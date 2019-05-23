defmodule FeedbackApiWeb.Survey.UserAverageController do
  use FeedbackApiWeb, :controller
  alias FeedbackApi.Survey

  def show(conn, params) do
    average = Survey.user_averages(params["survey_id"])

    render(conn, "show.json", %{average: average})
  end
end
