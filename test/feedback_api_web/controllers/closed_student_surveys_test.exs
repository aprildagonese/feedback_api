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

    answer = Ecto.build_assoc(question, :answers, %{description: "One", value: 1})

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

    answer_2 =
      Ecto.build_assoc(question_2, :answers, %{description: "One", value: 1})
      |> Repo.insert!()

    :ok
  end

  test "Returns closed surveys where the user was a participant", %{conn: conn} do
    [_, survey] = Repo.all(Survey) |> Repo.preload([:groups, :questions])
    [question] = survey.questions
    [group] = survey.groups
    [user, user_2] = Repo.all(User)
    [_, question] = Repo.all(Question) |> Repo.preload(:answers)
    [answer] = question.answers

    uri = "/api/v1/surveys/closed?api_key=#{user.api_key}"

    conn = get(conn, uri)

    expected = [
      %{
        "id" => survey.id,
        "surveyName" => survey.name,
        "surveyExpiration" => nil,
        "created_at" => NaiveDateTime.to_iso8601(survey.inserted_at),
        "updated_at" => NaiveDateTime.to_iso8601(survey.updated_at),
        "status" => "Closed",
        "questions" => [
          %{
            "id" => question.id,
            "questionTitle" => "Pick a number between one and four",
            "options" => [
              %{"description" => "One", "pointValue" => 1, "id" => answer.id}
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
    [user, _] = Repo.all(User)
    uri = "/api/v1/surveys/closed"

    conn = get(conn, uri)

    assert json_response(conn, 401) == %{"error" => "Invalid API Key"}
  end
end
