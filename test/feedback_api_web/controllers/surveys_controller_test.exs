defmodule FeedbackApiWeb.SurveysControllerTest do
  use FeedbackApiWeb.ConnCase
  alias FeedbackApi.{Cohort, User, Survey, Repo}

  setup do
    cohorts = [%{id: 1, name: "1811", program: "b"}, %{id: 2, name: "1811", program: "f"}]
    cohort_changesets = Enum.map(cohorts, fn cohort -> Cohort.changeset(%Cohort{}, cohort) end)
    Enum.map(cohort_changesets, fn changeset -> Repo.insert(changeset) end)

    students = [
      %{id: 1, cohort_id: 1},
      %{id: 2, cohort_id: 1},
      %{id: 3, cohort_id: 1},
      %{id: 4, cohort_id: 2},
      %{id: 5, cohort_id: 2},
      %{id: 6, cohort_id: 2}
    ]

    student_changesets = Enum.map(students, fn student -> User.changeset(%User{}, student) end)
    Enum.map(student_changesets, fn changeset -> Repo.insert(changeset) end)
  end

  test "Create new survey", %{conn: conn} do
    conn = conn |> put_req_header("content-type", "application/json")
    body = File.read!("test/fixtures/survey_create.json")
    conn = post(conn, "/api/v1/surveys", body)
    assert json_response(conn, 201) == %{"success" => "Survey stored"}
    assert Survey |> Repo.aggregate(:count, :id) == 1
  end
end
