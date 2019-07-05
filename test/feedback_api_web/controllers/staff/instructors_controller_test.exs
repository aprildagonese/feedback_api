defmodule FeedbackApiWeb.Staff.InstructorsControllerTest do
   use FeedbackApiWeb.ConnCase

   alias FeedbackApi.{Repo, User}

   setup do
      instructor_1 = %User{name: "Mike Dao", api_key: "redlobster", role: :Instructor} |> Repo.insert!()
      instructor_2 = %User{name: "Josh Mejia", api_key: "getofftheshed", role: :Instructor} |> Repo.insert!()
      inactive_instructor = %User{name: "Hashtag Steve", status: :Inactive, role: :Instructor} |> Repo.insert!()
      student = %User{name: "Tyler", role: :Student} |> Repo.insert!()
      {:ok, users: [instructor_1, instructor_2, inactive_instructor, student]}
   end

   test "Returns a list of all other active staff members in the system", %{conn: conn, users: [mike, josh, _inactive, _student]} do
      conn = get(conn, "/api/v2/staff/instructors?api_key=#{mike.api_key}")

      expected = [
         %{
            id: josh.id,
            name: josh.name
         }
      ]

      assert json_response(conn, 200) == expected
   end
end
