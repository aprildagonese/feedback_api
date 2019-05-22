defmodule FeedbackApiWeb.Surveys.AverageController do
  use FeedbackApiWeb, :controller
  alias FeedbackApi.Survey

  def index(conn, params) do
    averages = Survey.class_averages(params["survey_id"])

    render(conn, "index.json", %{averages: averages})
  end

  def show(conn, params) do
    average = Survey.group_averages(params["survey_id"], params["group_id"])

    render(conn, "show.json", %{average: average})
  end

end
