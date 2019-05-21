defmodule FeedbackApiWeb.CohortController do
  use FeedbackApiWeb, :controller
  alias FeedbackApi.{Repo, Cohort}

  def index(conn, _params) do
    cohorts = Repo.all(Cohort)
    render(conn, "index.json", %{cohorts: cohorts})
  end
end
