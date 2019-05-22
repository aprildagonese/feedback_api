defmodule FeedbackApiWeb.CohortController do
  use FeedbackApiWeb, :controller
  alias FeedbackApi.{Repo, Cohort}
  import Ecto.Query

  def index(conn, _params) do
    cohorts = Repo.all(from c in Cohort, where: c.status == 0)
    render(conn, "index.json", %{cohorts: cohorts})
  end
end
