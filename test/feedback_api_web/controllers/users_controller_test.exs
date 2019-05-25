defmodule FeedbackApiWeb.UsersControllerTest do
  use FeedbackApiWeb.ConnCase
  alias FeedbackApi.{Cohort, User, Repo}
  import Ecto.Query

  setup do
    cohort_1811 = %Cohort{name: "1811"}
    |> Repo.insert!()

    cohort_1901 = %Cohort{name: "1901"}

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

    Enum.map(students_1811, fn student -> Ecto.build_assoc(cohort_1811, :users, student) |> Repo.insert!() end)
    Enum.map(students_1901, fn student -> Ecto.build_assoc(cohort_1901, :users, student) |> Repo.insert!() end)
    %User{name: "Mike Dao", role: :Instructor} |> Repo.insert!()
    :ok
  end

  describe "Users index returns active students" do
    test "without any filters", %{conn: conn} do
      conn = get(conn, "/api/v1/students")

      expected = %{
        "students" => [
          %{
            "name" => "Peter Lapicola",
            "cohort" => "1811",
            "program" => "B",
            "status" => "Active"
          },
          %{
            "name" => "April Dagonese",
            "cohort" => "1811",
            "program" => "B",
            "status" => "Active"
          },
          %{
            "name" => "Kim Myers",
            "cohort" => "1811",
            "program" => "F",
            "status" => "Active"
          },
          %{
            "name" => "Taylor Sperry",
            "cohort" => "1811",
            "program" => "F",
            "status" => "Active"
          },
          %{
            "name" => "Jennica Stiehl",
            "cohort" => "1901",
            "program" => "B",
            "status" => "Active"
          },
          %{
            "name" => "Earl Stephens",
            "cohort" => "1901",
            "program" => "B",
            "status" => "Active"
          },
          %{
            "name" => "Justin Pyktel",
            "cohort" => "1901",
            "program" => "F",
            "status" => "Active"
          },
          %{
            "name" => "Raechel Odom",
            "cohort" => "1901",
            "program" => "F",
            "status" => "Active"
          }
        ]
      }

      assert json_response(conn, 200) == expected
    end

    test "Filtered by cohort", %{conn: conn} do
      conn = get(conn, "/api/v1/students?cohort=1811")

      expected = %{
        "students" => [
          %{
            "name" => "Peter Lapicola",
            "cohort" => "1811",
            "program" => "B",
            "status" => "Active"
          },
          %{
            "name" => "April Dagonese",
            "cohort" => "1811",
            "program" => "B",
            "status" => "Active"
          },
          %{
            "name" => "Kim Myers",
            "cohort" => "1811",
            "program" => "F",
            "status" => "Active"
          },
          %{
            "name" => "Taylor Sperry",
            "cohort" => "1811",
            "program" => "F",
            "status" => "Active"
          }
        ]
      }

      assert json_response(conn, 200) == expected
    end

    test "Filtered by program", %{conn: conn} do
      conn = get(conn, "/api/v1/students?program=B")

      expected = %{
        "students" => [
          %{
            "name" => "Peter Lapicola",
            "cohort" => "1811",
            "program" => "B",
            "status" => "Active"
          },
          %{
            "name" => "April Dagonese",
            "cohort" => "1811",
            "program" => "B",
            "status" => "Active"
          },
          %{
            "name" => "Jennica Stiehl",
            "cohort" => "1901",
            "program" => "B",
            "status" => "Active"
          },
          %{
            "name" => "Earl Stephens",
            "cohort" => "1901",
            "program" => "B",
            "status" => "Active"
          }
        ]
      }

      assert json_response(conn, 200) == expected
    end

    test "By cohort and program", %{conn: conn} do
      conn = get(conn, "/api/v1/students?cohort=1811&program=B")

      expected = %{
        "students" => [
          %{
            "name" => "Peter Lapicola",
            "cohort" => "1811",
            "program" => "B",
            "status" => "Active"
          },
          %{
            "name" => "April Dagonese",
            "cohort" => "1811",
            "program" => "B",
            "status" => "Active"
          }
        ]
      }

      assert json_response(conn, 200) == expected
    end
  end
end
