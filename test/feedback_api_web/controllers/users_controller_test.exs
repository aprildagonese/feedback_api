defmodule FeedbackApiWeb.UsersControllerTest do
  use FeedbackApiWeb.ConnCase
  alias FeedbackApi.{Cohort, User, Repo}

  setup do
    cohort_1811 =
      %Cohort{name: "1811"}
      |> Repo.insert!()

    cohort_1901 =
      %Cohort{name: "1901"}
      |> Repo.insert!()

    %User{name: "Inactive Student", program: "B", status: :Inactive} |> Repo.insert!()

    students_1811 = [
      %{name: "Peter Lapicola", program: "B"},
      %{name: "April Dagonese", program: "B"},
      %{name: "Kim Myers", program: "F"},
      %{name: "Taylor Sperry", program: "F"}
    ]

    students_1901 = [
      %{name: "Jennica Stiehl", program: "B"},
      %{name: "Earl Stephens", program: "B"},
      %{name: "Justin Pyktel", program: "F"},
      %{name: "Raechel Odom", program: "F"}
    ]

    Enum.map(students_1811, fn student ->
      Ecto.build_assoc(cohort_1811, :users, student) |> Repo.insert!()
    end)

    Enum.map(students_1901, fn student ->
      Ecto.build_assoc(cohort_1901, :users, student) |> Repo.insert!()
    end)

    %User{name: "Mike Dao", role: :Instructor} |> Repo.insert!()
    :ok
  end

  describe "Users index returns active students" do
    test "without any filters", %{conn: conn} do
      [_, user_1, user_2, user_3, user_4, user_5, user_6, user_7, user_8, _] = Repo.all(User)
      conn = get(conn, "/api/v1/students")

      expected = [
        %{
          "id" => user_1.id,
          "name" => "Peter Lapicola",
          "cohort" => "1811",
          "program" => "B",
          "status" => "Active"
        },
        %{
          "id" => user_2.id,
          "name" => "April Dagonese",
          "cohort" => "1811",
          "program" => "B",
          "status" => "Active"
        },
        %{
          "id" => user_3.id,
          "name" => "Kim Myers",
          "cohort" => "1811",
          "program" => "F",
          "status" => "Active"
        },
        %{
          "id" => user_4.id,
          "name" => "Taylor Sperry",
          "cohort" => "1811",
          "program" => "F",
          "status" => "Active"
        },
        %{
          "id" => user_5.id,
          "name" => "Jennica Stiehl",
          "cohort" => "1901",
          "program" => "B",
          "status" => "Active"
        },
        %{
          "id" => user_6.id,
          "name" => "Earl Stephens",
          "cohort" => "1901",
          "program" => "B",
          "status" => "Active"
        },
        %{
          "id" => user_7.id,
          "name" => "Justin Pyktel",
          "cohort" => "1901",
          "program" => "F",
          "status" => "Active"
        },
        %{
          "id" => user_8.id,
          "name" => "Raechel Odom",
          "cohort" => "1901",
          "program" => "F",
          "status" => "Active"
        }
      ]

      assert json_response(conn, 200) == expected
    end

    test "Filtered by cohort", %{conn: conn} do
      [_, user_1, user_2, user_3, user_4, _, _, _, _, _] = Repo.all(User)
      conn = get(conn, "/api/v1/students?cohort=1811")

      expected = [
        %{
          "id" => user_1.id,
          "name" => "Peter Lapicola",
          "cohort" => "1811",
          "program" => "B",
          "status" => "Active"
        },
        %{
          "id" => user_2.id,
          "name" => "April Dagonese",
          "cohort" => "1811",
          "program" => "B",
          "status" => "Active"
        },
        %{
          "id" => user_3.id,
          "name" => "Kim Myers",
          "cohort" => "1811",
          "program" => "F",
          "status" => "Active"
        },
        %{
          "id" => user_4.id,
          "name" => "Taylor Sperry",
          "cohort" => "1811",
          "program" => "F",
          "status" => "Active"
        }
      ]

      assert json_response(conn, 200) == expected
    end

    test "Filtered by program", %{conn: conn} do
      [_, user_1, user_2, _, _, user_5, user_6, _, _, _] = Repo.all(User)
      conn = get(conn, "/api/v1/students?program=B")

      expected = [
        %{
          "id" => user_1.id,
          "name" => "Peter Lapicola",
          "cohort" => "1811",
          "program" => "B",
          "status" => "Active"
        },
        %{
          "id" => user_2.id,
          "name" => "April Dagonese",
          "cohort" => "1811",
          "program" => "B",
          "status" => "Active"
        },
        %{
          "id" => user_5.id,
          "name" => "Jennica Stiehl",
          "cohort" => "1901",
          "program" => "B",
          "status" => "Active"
        },
        %{
          "id" => user_6.id,
          "name" => "Earl Stephens",
          "cohort" => "1901",
          "program" => "B",
          "status" => "Active"
        }
      ]

      assert json_response(conn, 200) == expected
    end

    test "By cohort and program", %{conn: conn} do
      [_, user_1, user_2, _, _, _, _, _, _, _] = Repo.all(User)
      conn = get(conn, "/api/v1/students?cohort=1811&program=B")

      expected = [
        %{
          "id" => user_1.id,
          "name" => "Peter Lapicola",
          "cohort" => "1811",
          "program" => "B",
          "status" => "Active"
        },
        %{
          "id" => user_2.id,
          "name" => "April Dagonese",
          "cohort" => "1811",
          "program" => "B",
          "status" => "Active"
        }
      ]

      assert json_response(conn, 200) == expected
    end
  end
end
