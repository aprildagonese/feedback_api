defmodule FeedbackApiWeb.SurveysControllerTest do
  use FeedbackApiWeb.ConnCase
  alias FeedbackApi.{Cohort, Survey, Question, Repo}

  setup do
    cohorts = [%{id: 1, name: "1811"}, %{id: 2, name: "1811"}]
    cohort_changesets = Enum.map(cohorts, fn cohort -> Cohort.changeset(%Cohort{}, cohort) end)

    [cohort_1, cohort_2] =
      Enum.map(cohort_changesets, fn changeset ->
        Repo.insert!(changeset) |> Repo.preload([:users])
      end)

    cohort_1_students = [
      %{id: 1, cohort_id: 1},
      %{id: 2, cohort_id: 1},
      %{id: 3, cohort_id: 1}
    ]

    cohort_2_students = [
      %{id: 4, cohort_id: 2},
      %{id: 5, cohort_id: 2},
      %{id: 6, cohort_id: 2}
    ]

    Enum.map(cohort_1_students, fn student ->
      Ecto.build_assoc(cohort_1, :users, student) |> Repo.insert!()
    end)

    Enum.map(cohort_2_students, fn student ->
      Ecto.build_assoc(cohort_2, :users, student) |> Repo.insert!()
    end)

    survey = Survey.changeset(%Survey{}, %{name: "A test survey"}) |> Repo.insert!()

    question =
      Question.changeset(%Question{}, %{text: "What is this?"})
      |> Repo.insert!()
      |> Repo.preload([:survey, :answers])

    Ecto.build_assoc(question, :answers, %{description: "A thing", value: 3}) |> Repo.insert!()
    Ecto.Changeset.change(question) |> Ecto.Changeset.put_assoc(:survey, survey) |> Repo.update!()
    Ecto.build_assoc(survey, :groups, %{name: "Small group"})
    :ok
  end

  test "Create new survey", %{conn: conn} do
    conn = conn |> put_req_header("content-type", "application/json")
    body = File.read!("test/fixtures/survey_create.json")

    conn = post(conn, "/api/v1/surveys", body)

    assert json_response(conn, 201) == %{"success" => "Survey stored"}
    assert Survey |> Repo.aggregate(:count, :id) == 2
  end

  test "Return all surveys", %{conn: conn} do
    survey = Repo.one(Survey)
    conn = get(conn, "/api/v1/surveys")

    expected = [
      %{
        "groups" => [],
        "name" => "A test survey",
        "id" => survey.id,
        "exp_date" => nil,
        "created_at" => NaiveDateTime.to_iso8601(survey.inserted_at),
        "updated_at" => NaiveDateTime.to_iso8601(survey.updated_at),
        "questions" => [
          %{
            "answers" => [%{"description" => "A thing", "value" => 3}],
            "text" => "What is this?"
          }
        ],
        "status" => "active"
      }
    ]

    assert expected == json_response(conn, 200)
  end
end