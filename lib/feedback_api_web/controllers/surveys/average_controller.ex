defmodule FeedbackApiWeb.Surveys.AverageController do
  use FeedbackApiWeb, :controller
  alias FeedbackApiWeb.Survey

  def index(conn, params) do
    Survey.survey_with_averages(params["survey_id"])
  end

  def show(conn, params) do
    # Work in progress
  end

end
