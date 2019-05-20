defmodule FeedbackApiWeb.CohortsControllerTest do
  use FeedbackApiWeb.ConnCase
  alias FeedbackApi.{Repo, Cohort}

  setup do
    cohorts = [%{id: 1, name: "1811"}, %{id: 2, name: "1901"}]
    cohort_changesets = Enum.map(cohorts, fn cohort -> Cohort.changeset(%Cohort{}, cohort) end)
    Enum.map(cohort_changesets, fn changeset ->
      Repo.insert!(changeset)
    end)
    :ok
  end

  test "It returns a list of all cohorts", %{conn: conn} do
    cohorts = Cohort |> Repo.all
    conn = get(conn, "/api/v1/cohorts")

    expected = [
      %{"name" => "1811",
        "id" => cohorts[0].id},
      %{"name" => "1901",
        "id" => cohorts[1].id}
    ]

    assert json_response(conn, 200) == expected
  end
end
