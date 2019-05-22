defmodule FeedbackApiWeb.CohortsControllerTest do
  use FeedbackApiWeb.ConnCase
  alias FeedbackApi.{Repo, Cohort}

  setup do
    cohorts = [%{id: 1, status: :Active, name: "1811"}, %{id: 2, status: :Active, name: "1901"}]
    cohort_changesets = Enum.map(cohorts, fn cohort -> Cohort.changeset(%Cohort{}, cohort) end)
    Enum.map(cohort_changesets, fn changeset ->
      Repo.insert!(changeset)
    end)
    :ok
  end

  test "It returns a list of all cohorts", %{conn: conn} do
    [cohort_1, cohort_2] = Cohort |> Repo.all
    conn = get(conn, "/api/v1/cohorts")

    expected = [
      %{"name" => "1811",
        "id" => cohort_1.id,
        "status" => "Active"},
      %{"name" => "1901",
        "id" => cohort_2.id,
        "status" => "Active"}
    ]

    assert json_response(conn, 200) == expected
  end
end
