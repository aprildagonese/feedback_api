defmodule FeedbackApiWeb.SurveysControllerTest do
  use FeedbackApiWeb.ConnCase
  alias FeedbackApi.{Cohort, Survey, User, Question, Answer, Repo}

  setup do
    %User{api_key: "wxyz897", role: :Instructor} |> Repo.insert!()

    mikedaowl = 
      %User{api_key: "mikedaowl", role: :Instructor}
      |> Repo.insert!()

    survey =
      %Survey{name: "A test survey"}
      |> Repo.insert!()
      |> Repo.preload(:owners)
      |> Ecto.Changeset.change
      |> Ecto.Changeset.put_assoc(:owners, [mikedaowl])
      |> Repo.update!()

    cohorts = [%{id: 1, status: :Active, name: "1811"}, %{id: 2, status: :Active, name: "1811"}]
    cohort_changesets = Enum.map(cohorts, fn cohort -> Cohort.changeset(%Cohort{}, cohort) end)

    [cohort_1, cohort_2] =
      Enum.map(cohort_changesets, fn changeset ->
        Repo.insert!(changeset) |> Repo.preload([:users])
      end)

    cohort_1_students = [
      %{cohort_id: 1, api_key: "abcdef123"},
      %{cohort_id: 1, api_key: "321fedcba"},
      %{cohort_id: 1, api_key: "aaawtf"}
    ]

    cohort_2_students = [
      %{cohort_id: 2},
      %{cohort_id: 2},
      %{cohort_id: 2}
    ]

    Enum.map(cohort_1_students, fn student ->
      Ecto.build_assoc(cohort_1, :users, student) |> Repo.insert!()
    end)

    Enum.map(cohort_2_students, fn student ->
      Ecto.build_assoc(cohort_2, :users, student) |> Repo.insert!()
    end)

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

  test "Survey creation fails if no API key is provided", %{conn: conn} do
    conn = conn |> put_req_header("content-type", "application/json")
    body = File.read!("test/fixtures/failed_survey_create.json")

    conn = post(conn, "/api/v1/surveys", body)

    assert json_response(conn, 401) == %{"error" => "Invalid API Key"}
  end

  test "Return all surveys for the user", %{conn: conn} do
    survey = Repo.one(Survey)
    question = Repo.one(Question)
    answer = Repo.one(Answer)
    conn = get(conn, "/api/v1/surveys?api_key=mikedaowl")

    expected = [
      %{
        "groups" => [],
        "surveyName" => "A test survey",
        "id" => survey.id,
        "surveyExpiration" => nil,
        "created_at" => NaiveDateTime.to_iso8601(survey.inserted_at),
        "updated_at" => NaiveDateTime.to_iso8601(survey.updated_at),
        "questions" => [
          %{
            "id" => question.id,
            "options" => [%{"description" => "A thing", "pointValue" => 3, "id" => answer.id}],
            "questionTitle" => "What is this?"
          }
        ],
        "status" => "Active"
      }
    ]

    assert expected == json_response(conn, 200)
  end

  test "GET Surveys Returns a 401 if an API key is invalid", %{conn: conn} do
    conn = get(conn, "/api/v1/surveys?api_key=fakeapikey")

    expected = %{
      "error" => "Invalid API Key"
    }

    assert json_response(conn, 401) == expected
  end

  test "Return a single survey", %{conn: conn} do
    survey = Repo.one(Survey)
    question = Repo.one(Question)
    answer = Repo.one(Answer)
    conn = get(conn, "/api/v1/surveys/#{survey.id}")

    expected = %{
      "groups" => [],
      "surveyName" => "A test survey",
      "id" => survey.id,
      "surveyExpiration" => nil,
      "created_at" => NaiveDateTime.to_iso8601(survey.inserted_at),
      "updated_at" => NaiveDateTime.to_iso8601(survey.updated_at),
      "questions" => [
        %{
          "id" => question.id,
          "options" => [%{"description" => "A thing", "pointValue" => 3, "id" => answer.id}],
          "questionTitle" => "What is this?"
        }
      ],
      "status" => "Active"
    }

    assert expected == json_response(conn, 200)
  end

  test "GET Surveys Returns no surveys if the user does not own any", %{conn: conn} do
    conn = get(conn, "/api/v1/surveys?api_key=wxyz897")

    expected = []

    assert json_response(conn, 200) == expected
  end

  test "Student should receive status 401", %{conn: conn} do
    conn = get(conn, "/api/v1/surveys?api_key=abcdef123")

    expected = %{"error" => "Invalid API Key"}

    assert json_response(conn, 401) == expected
  end
end
