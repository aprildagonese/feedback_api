defmodule FeedbackApiWeb.PendingSurveysTest do
  use FeedbackApiWeb.ConnCase
  alias FeedbackApi.{Cohort, Group, Survey, Question, Answer, Repo}

  setup do
    cohort = %Cohort{name: "1811", status: :Active} |> Repo.insert!() |> Repo.preload(:users)

    students = [
      %{name: "User 1", program: "B", api_key: "abc123"},
      %{name: "User 2", program: "B", api_key: "123abc"},
      %{name: "User 3", program: "B"}
    ]

    users =
      Enum.map(students, fn student ->
        Ecto.build_assoc(cohort, :users, student)
        |> Repo.insert!()
        |> Repo.preload([:responses, :ratings])
      end)

    # User_1 : 3.5, User_2 : 3, User_3 : nil
    [user_1, user_2, user_3] = users

    survey =
      Ecto.build_assoc(user_3, :surveys, %Survey{name: "Test Survey"})
      |> Repo.insert!()
      |> Repo.preload([:groups, :questions])

    group =
      Ecto.build_assoc(survey, :groups, %{name: "Test"})
      |> Repo.insert!()
      |> Repo.preload([:users, :survey])

    Ecto.Changeset.put_assoc(Ecto.Changeset.change(group), :users, users) |> Repo.update!()

    question =
      Ecto.build_assoc(survey, :questions, %{text: "Pick a number between one and four"})
      |> Repo.insert!()
      |> Repo.preload(:answers)

    answer_list = [
      %{description: "One", value: 1},
      %{description: "Two", value: 2},
      %{description: "Three", value: 3},
      %{description: "Four", value: 4}
    ]

    [_answer_1, _answer_2, answer_3, answer_4] =
      Enum.map(answer_list, fn answer ->
        Ecto.build_assoc(question, :answers, answer) |> Repo.insert!()
      end)

    response_1 =
      Ecto.build_assoc(answer_4, :responses, %{})
      |> Repo.insert!()
      |> Repo.preload([:reviewer, :recipient, :answer, :question])

    Ecto.Changeset.put_assoc(Ecto.Changeset.change(response_1), :recipient, user_1)
    |> Repo.update!()

    Ecto.Changeset.put_assoc(Ecto.Changeset.change(response_1), :reviewer, user_2)
    |> Repo.update!()

    Ecto.Changeset.put_assoc(Ecto.Changeset.change(response_1), :question, question)
    |> Repo.update!()

    response_2 =
      Ecto.build_assoc(answer_3, :responses, %{})
      |> Repo.insert!()
      |> Repo.preload([:reviewer, :recipient, :answer, :question])

    Ecto.Changeset.put_assoc(Ecto.Changeset.change(response_2), :recipient, user_3)
    |> Repo.update!()

    Ecto.Changeset.put_assoc(Ecto.Changeset.change(response_2), :reviewer, user_2)
    |> Repo.update!()

    Ecto.Changeset.put_assoc(Ecto.Changeset.change(response_2), :question, question)
    |> Repo.update!()

    survey_2 =
      Ecto.build_assoc(user_2, :surveys, %Survey{name: "Test Survey Two"})
      |> Repo.insert!()
      |> Repo.preload([:groups, :questions])

    group_2 =
      Ecto.build_assoc(survey_2, :groups, %{name: "Group Two!"})
      |> Repo.insert!()
      |> Repo.preload([:users, :survey])

    Ecto.Changeset.put_assoc(Ecto.Changeset.change(group_2), :users, users) |> Repo.update!()

    question_two =
      Ecto.build_assoc(survey_2, :questions, %{text: "Another Question"})
      |> Repo.insert!()
      |> Repo.preload(:answers)

    Ecto.build_assoc(question_two, :answers, %{description: "One", value: 1})
    |> Repo.insert!()

    closed_survey =
      Ecto.build_assoc(user_3, :surveys, %Survey{name: "Test Survey", status: :Closed})
      |> Repo.insert!()
      |> Repo.preload([:groups, :questions])

    closed_group =
      Ecto.build_assoc(closed_survey, :groups, %{name: "Test Closed"})
      |> Repo.insert!()
      |> Repo.preload([:users, :survey])

    Ecto.Changeset.put_assoc(Ecto.Changeset.change(closed_group), :users, users) |> Repo.update!()

    closed_question =
      Ecto.build_assoc(closed_survey, :questions, %{text: "Another Question"})
      |> Repo.insert!()
      |> Repo.preload(:answers)

    Ecto.build_assoc(closed_question, :answers, %{description: "One", value: 1})
    |> Repo.insert!()

    :ok
  end

  test "Returns surveys pending for a user", %{conn: conn} do
    [survey_1, survey_2, _survey_3] = Repo.all(Survey)
    [question_1, question_2, _question_3] = Repo.all(Question)
    [answer_1, answer_2, answer_3, answer_4, answer_5, _answer_6] = Repo.all(Answer)
    [group_1, _group_2, _group_3] = Repo.all(Group) |> Repo.preload(:users)
    [user_1, user_2, user_3] = group_1.users

    uri = "/api/v1/surveys/pending?api_key=#{user_1.api_key}"

    conn = get(conn, uri)

    expected = [
      %{
        "groups" => [
          %{
            "members" => [
              %{
                "id" => user_2.id,
                "name" => user_2.name,
                "cohort" => "1811",
                "program" => "B",
                "status" => "Active"
              },
              %{
                "id" => user_3.id,
                "name" => user_3.name,
                "cohort" => "1811",
                "program" => "B",
                "status" => "Active"
              }
            ],
            "name" => "Test"
          }
        ],
        "surveyName" => "Test Survey",
        "id" => survey_1.id,
        "surveyExpiration" => nil,
        "created_at" => NaiveDateTime.to_iso8601(survey_1.inserted_at),
        "updated_at" => NaiveDateTime.to_iso8601(survey_1.updated_at),
        "questions" => [
          %{
            "options" => [
              %{
                "description" => "Four",
                "pointValue" => 4,
                "id" => answer_4.id
              },
              %{
                "description" => "Three",
                "pointValue" => 3,
                "id" => answer_3.id
              },
              %{
                "description" => "Two",
                "pointValue" => 2,
                "id" => answer_2.id
              },
              %{
                "description" => "One",
                "pointValue" => 1,
                "id" => answer_1.id
              }
            ],
            "id" => question_1.id,
            "questionTitle" => "Pick a number between one and four"
          }
        ],
        "status" => "Active"
      },
      %{
        "groups" => [
        %{
          "members" => [
            %{
              "id" => user_2.id,
              "name" => user_2.name,
              "cohort" => "1811",
              "program" => "B",
              "status" => "Active"
            },
            %{
              "id" => user_3.id,
              "name" => user_3.name,
              "cohort" => "1811",
              "program" => "B",
              "status" => "Active"
            }
          ],
          "name" => "Group Two!"
        }
      ],
      "surveyName" => "Test Survey Two",
      "id" => survey_2.id,
      "surveyExpiration" => nil,
      "created_at" => NaiveDateTime.to_iso8601(survey_2.inserted_at),
      "updated_at" => NaiveDateTime.to_iso8601(survey_2.updated_at),
      "questions" => [
        %{
          "options" => [
            %{
              "description" => "One",
              "pointValue" => 1,
              "id" => answer_5.id
            }
          ],
          "id" => question_2.id,
          "questionTitle" => "Another Question"
        }
      ],
      "status" => "Active"
    }
    ]

    assert json_response(conn, 200) == expected
  end

  test "Doesn't return completed surveys", %{conn: conn} do
    [_survey_1, survey_2, _survey_3] = Repo.all(Survey)
    [_question_1, question_2, _question_3] = Repo.all(Question)
    [_answer_1, _answer_2, _answer_3, _answer_4, answer_5, _answer_6] = Repo.all(Answer)
    [group_1, _group_2, _group_3] = Repo.all(Group) |> Repo.preload(:users)
    [user_1, user_2, user_3] = group_1.users

    uri = "/api/v1/surveys/pending?api_key=#{user_2.api_key}"

    conn = get(conn, uri)

    expected = [
      %{
        "groups" => [
        %{
          "members" => [
            %{
              "id" => user_1.id,
              "name" => user_1.name,
              "cohort" => "1811",
              "program" => "B",
              "status" => "Active"
            },
            %{
              "id" => user_3.id,
              "name" => user_3.name,
              "cohort" => "1811",
              "program" => "B",
              "status" => "Active"
            }
          ],
          "name" => "Group Two!"
        }
      ],
      "surveyName" => "Test Survey Two",
      "id" => survey_2.id,
      "surveyExpiration" => nil,
      "created_at" => NaiveDateTime.to_iso8601(survey_2.inserted_at),
      "updated_at" => NaiveDateTime.to_iso8601(survey_2.updated_at),
      "questions" => [
        %{
          "options" => [
            %{
              "description" => "One",
              "pointValue" => 1,
              "id" => answer_5.id
            }
          ],
          "id" => question_2.id,
          "questionTitle" => "Another Question"
        }
      ],
      "status" => "Active"
    }
  ]

  assert json_response(conn, 200) == expected
  end

  test "Returns a 401 if key is invalid", %{conn: conn} do
    uri = "/api/v1/surveys/pending?api_key=fakeapikey"
    conn = get(conn, uri)

    assert json_response(conn, 401) == %{"error" => "Invalid API Key"}
  end
end
