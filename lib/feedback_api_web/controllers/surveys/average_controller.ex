defmodule FeedbackApiWeb.Surveys.AverageController do
  use FeedbackApiWeb, :controller
  alias FeedbackApi.Survey

  def index(conn, params) do
    averages = Survey.class_averages(params["survey_id"])

    render(conn, "index.json", %{averages: averages})
  end

  def show(conn, params) do
    # Work in progress
  end

end
