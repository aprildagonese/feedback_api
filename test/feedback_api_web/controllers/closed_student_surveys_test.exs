defmodule FeedbackApiWeb.ClosedStudentSurveysTest do
  use FeedbackApiWeb.ConnCase
  alias FeedbackApi.{Repo, Cohort, User, Question, Survey}

  setup do
    cohort = %Cohort{name: "1811", status: :Active} |> Repo.insert!() |> Repo.preload(:users)

    user =
      Ecto.build_assoc(cohort, :users, %{name: "User 1", program: "B", api_key: "abc123"})
      |> Repo.insert!()
      |> Repo.preload([:responses, :ratings])

    user_2 =
      Ecto.build_assoc(cohort, :users, %{name: "User 2", program: "B", api_key: "123abc"})
      |> Repo.insert!()
      |> Repo.preload([:responses, :ratings])

    survey =
      Ecto.build_assoc(user, :surveys, %Survey{name: "Open Survey"})
      |> Repo.insert!()
      |> Repo.preload([:groups, :questions])

    group =
      Ecto.build_assoc(survey, :groups, %{name: "Test"})
      |> Repo.insert!()
      |> Repo.preload([:users, :survey])

    Ecto.Changeset.put_assoc(Ecto.Changeset.change(group), :users, [user, user_2])
    |> Repo.update!()

    question =
      Ecto.build_assoc(survey, :questions, %{text: "Pick a number between one and four"})
      |> Repo.insert!()
      |> Repo.preload(:answers)

    Ecto.build_assoc(question, :answers, %{description: "One", value: 1})

    survey_2 =
      Ecto.build_assoc(user, :surveys, %Survey{name: "Closed Survey", status: 1})
      |> Repo.insert!()
      |> Repo.preload([:groups, :questions])

    group_2 =
      Ecto.build_assoc(survey_2, :groups, %{name: "Test"})
      |> Repo.insert!()
      |> Repo.preload([:users, :survey])

    Ecto.Changeset.put_assoc(Ecto.Changeset.change(group_2), :users, [user, user_2])
    |> Repo.update!()

    question_2 =
      Ecto.build_assoc(survey_2, :questions, %{text: "Pick a number between one and four"})
      |> Repo.insert!()
      |> Repo.preload(:answers)

    Ecto.build_assoc(question_2, :answers, %{description: "One", value: 1})
    |> Repo.insert!()

    survey_3 =
      Ecto.build_assoc(user, :surveys, %Survey{name: "Closed Survey Two", status: 1})
      |> Repo.insert!()
      |> Repo.preload([:groups, :questions])

    group_3 =
      Ecto.build_assoc(survey_3, :groups, %{name: "Test"})
      |> Repo.insert!()
      |> Repo.preload([:users, :survey])

    Ecto.Changeset.put_assoc(Ecto.Changeset.change(group_3), :users, [user, user_2])
    |> Repo.update!()

    question_3 =
      Ecto.build_assoc(survey_3, :questions, %{text: "Pick a number between one and four"})
      |> Repo.insert!()
      |> Repo.preload(:answers)

    Ecto.build_assoc(question_3, :answers, %{description: "One", value: 1})
    |> Repo.insert!()

    :ok
  end

  test "Returns closed surveys where the user was a participant", %{conn: conn} do
    [_, survey_2, survey_3] = Repo.all(Survey) |> Repo.preload([:groups, :questions])
    [user, user_2] = Repo.all(User)
    [_, question_1, question_2] = Repo.all(Question) |> Repo.preload(:answers)
    [answer_1] = question_1.answers
    [answer_2] = question_2.answers

    uri = "/api/v1/surveys/closed?api_key=#{user.api_key}"

    conn = get(conn, uri)

    expected = [
      %{
        "id" => survey_3.id,
        "surveyName" => survey_3.name,
        "surveyExpiration" => nil,
        "created_at" => NaiveDateTime.to_iso8601(survey_3.inserted_at),
        "updated_at" => NaiveDateTime.to_iso8601(survey_3.updated_at),
        "status" => "Closed",
        "questions" => [
          %{
            "id" => question_2.id,
            "questionTitle" => "Pick a number between one and four",
            "options" => [
              %{"description" => "One", "pointValue" => 1, "id" => answer_2.id}
            ]
          }
        ],
        "groups" => [
          %{
            "members" => [
              %{
                "id" => user_2.id,
                "name" => user_2.name,
                "cohort" => "1811",
                "program" => "B",
                "status" => "Active"
              }
            ],
            "name" => "Test"
          }
        ]
      },
      %{
        "id" => survey_2.id,
        "surveyName" => survey_2.name,
        "surveyExpiration" => nil,
        "created_at" => NaiveDateTime.to_iso8601(survey_2.inserted_at),
        "updated_at" => NaiveDateTime.to_iso8601(survey_2.updated_at),
        "status" => "Closed",
        "questions" => [
          %{
            "id" => question_1.id,
            "questionTitle" => "Pick a number between one and four",
            "options" => [
              %{"description" => "One", "pointValue" => 1, "id" => answer_1.id}
            ]
          }
        ],
        "groups" => [
          %{
            "members" => [
              %{
                "id" => user_2.id,
                "name" => user_2.name,
                "cohort" => "1811",
                "program" => "B",
                "status" => "Active"
              }
            ],
            "name" => "Test"
          }
        ]
      }
    ]

    assert json_response(conn, 200) == expected
  end

  test "Returns a 401 if an invalid key is provided", %{conn: conn} do
    uri = "/api/v1/surveys/closed"

    conn = get(conn, uri)

    assert json_response(conn, 401) == %{"error" => "Invalid API Key"}
  end
end
