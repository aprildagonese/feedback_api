defmodule FeedbackApiWeb.CohortView do
  use FeedbackApiWeb, :view
  alias FeedbackApiWeb.CohortView

  def render("index.json", %{cohorts: cohorts}) do
    render_many(cohorts, CohortView, "cohort.json")
  end

  def render("show.json", %{cohort: cohort}) do
    render_one(cohort, CohortView, "cohort.json")
  end

  def render("cohort.json", %{cohort: cohort}) do
    %{id: cohort.id, name: cohort.name}
  end
end
