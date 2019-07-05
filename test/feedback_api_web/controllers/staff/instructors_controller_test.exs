defmodule FeedbackApiWeb.Staff.InstructorsControllerTest do
   use FeedbackApiWeb.ConnCase

   alias FeedbackApi.{Repo, User}

   setup do
      instructor_1 = %User{name: "Mike Dao", api_key: "redlobster", role: :Instructor} |> Repo.insert!()
      instructor_2 = %User{name: "Josh Mejia", api_key: "getofftheshed", role: :Instructor} |> Repo.insert!()
      inactive_instructor = %User{name: "Hashtag Steve", status: :Inactive, role: :Instructor} |> Repo.insert!()
      student = %User{name: "Tyler", api_key: "dota" role: :Student} |> Repo.insert!()
      {:ok, users: [instructor_1, instructor_2, inactive_instructor, student]}
   end

   test "Returns a list of all other active staff members in the system", %{conn: conn, users: [mike, josh, _inactive, _student]} do
      conn = get(conn, "/api/v2/staff/instructors?api_key=#{mike.api_key}")

      expected = [
         %{
            "id" josh.id,
            "name" josh.name
         }
      ]

      assert json_response(conn, 200) == expected
   end

   test "Returns a 401 and invalid API key message if student credentials provided", %{conn: users: [_mike, _josh, _inactive, student]} do
      conn = get(conn, "/api/v2/staff/instructors?api_key=#{student.api_key}")

      expected = %{"error" => "Invalid API Key"}

      assert json_response(conn, 401) == expected
   end

   test "Returns a 401 and invalid key message if no credentials provided", %{conn: conn} do
      conn = get(conn, "/api/v2/staff/instructors")

      expected = %{"error" => "Invalid API Key"}

      assert json_response(conn, 401) == expected
   end

   test "Returns a 401 and invalid key message if account is inactive", %{conn: conn, users: [_mike, _josh, inactive, _student]} do
      conn = get(conn, "/api/v2/staff/instructors?api_key=#{inactive.api_key}")

      expected = %{"error" => "Invalid API Key"}

      assert json_response(conn, 401) == expected
   end
end
