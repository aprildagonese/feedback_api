defmodule FeedbackApiWeb.Api.V2.Staff.SurveyControllerTest do
  use FeedbackApiWeb.ConnCase

  alias FeedbackApi.{Repo, Survey, User, SurveyOwner}

  describe "Survey creation" do
    setup do
      conn = build_conn() |> put_req_header("content-type", "application/json")
      # Hardcode ID for multi owner survey creation in test suite
      josh =
        %User{id: 1, name: "Josh", api_key: "creepymustache", role: :Instructor} |> Repo.insert!()

      mike = %User{id: 2, name: "Mike", api_key: "mikedaowl", role: :Instructor} |> Repo.insert!()
      student = %User{name: "Julia", api_key: "justmarried"}
      {:ok, mike: mike, josh: josh, student: student, conn: conn}
    end

    test "Surveys can be created", %{conn: conn} do
      {:ok, body} = File.read("test/fixtures/v2_survey_create.json")

      conn = post(conn, "/api/v2/staff/surveys", body)

      assert json_response(conn, 201) == %{"success" => "Survey stored"}
      assert Repo.aggregate(Survey, :count, :id) == 1
      assert Repo.aggregate(SurveyOwner, :count, :id) == 2
    end

    test "Survey creation returns a 401 if no API key is provided", %{conn: conn} do
      {:ok, body} = File.read("test/fixtures/v2_survey_create_no_apikey.json")

      conn = post(conn, "/api/v2/staff/surveys", body)

      assert json_response(conn, 401) == %{"error" => "Invalid API Key"}
    end

    test "Survey creation returns a 401 if a student API key is provided", %{conn: conn} do
      {:ok, body} = File.read("test/fixtures/v2_survey_create_student_apikey.json")

      conn = post(conn, "/api/v2/staff/surveys", body)

      assert json_response(conn, 401) == %{"error" => "Invalid API Key"}
    end

    test "Surveys with missing information result in a 422 and an error message", %{conn: conn} do
      {:ok, body} = File.read("test/fixtures/v2_failed_survey_create.json") # Missing description for one question

      conn = post(conn, "/api/v2/staff/surveys", body)

      assert json_response(conn, 422) == %{"error" => "Missing required fields"}
      assert Repo.aggregate(Survey, :count, :id) == 0
    end
  end
end
