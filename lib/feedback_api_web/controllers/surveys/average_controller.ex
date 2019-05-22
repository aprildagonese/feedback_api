defmodule FeedbackApiWeb.Surveys.AverageController do
  use FeedbackApiWeb, :controller
  alias FeedbackApi.Survey

  def index(conn, params) do
    import IEx; IEx.pry()
    Survey.class_averages(params["surveys_id"])
  end

  def show(conn, params) do
    # Work in progress
  end

end
