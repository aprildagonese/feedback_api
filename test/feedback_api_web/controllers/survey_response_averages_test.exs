defmodule FeedbackApiWeb.SurveyResponseAveragesTest do
  use FeedbackApiWeb.ConnCase
  alias FeedbackApi.{Cohort, Group, Survey, Question, Answer, Repo}

  setup do
    cohort = %Cohort{name: "1811", status: :Active} |> Repo.insert!() |> Repo.preload(:users)

    students = [
      %{name: "User 1", program: "B", api_key: "user1"},
      %{name: "User 2", program: "B", api_key: "user2"},
      %{name: "User 3", program: "B", api_key: "user3"}
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

    Ecto.Changeset.put_assoc(Ecto.Changeset.change(response_1), :reviewer, user_3)
    |> Repo.update!()

    Ecto.Changeset.put_assoc(Ecto.Changeset.change(response_1), :question, question)
    |> Repo.update!()

    response_2 =
      Ecto.build_assoc(answer_3, :responses, %{})
      |> Repo.insert!()
      |> Repo.preload([:reviewer, :recipient, :answer, :question])

    Ecto.Changeset.put_assoc(Ecto.Changeset.change(response_2), :recipient, user_1)
    |> Repo.update!()

    Ecto.Changeset.put_assoc(Ecto.Changeset.change(response_2), :reviewer, user_2)
    |> Repo.update!()

    Ecto.Changeset.put_assoc(Ecto.Changeset.change(response_2), :question, question)
    |> Repo.update!()

    response_3 =
      Ecto.build_assoc(answer_3, :responses, %{})
      |> Repo.insert!()
      |> Repo.preload([:reviewer, :recipient, :answer, :question])

    Ecto.Changeset.put_assoc(Ecto.Changeset.change(response_3), :recipient, user_2)
    |> Repo.update!()

    Ecto.Changeset.put_assoc(Ecto.Changeset.change(response_3), :reviewer, user_1)
    |> Repo.update!()

    Ecto.Changeset.put_assoc(Ecto.Changeset.change(response_3), :question, question)
    |> Repo.update!()

    :ok
  end

  test "It can return the results from a survey for all groups", %{conn: conn} do
    survey = Repo.one(Survey)
    question = Repo.one(Question)
    [answer_1, answer_2, answer_3, answer_4] = Repo.all(Answer)
    group = Repo.one(Group) |> Repo.preload(:users)
    [user_1, user_2, user_3] = group.users

    uri = "/api/v1/surveys/#{survey.id}/averages"

    conn = get(conn, uri)

    expected = %{
      "survey" => %{
        "id" => survey.id,
        "surveyName" => survey.name,
        "surveyExpiration" => nil,
        "created_at" => NaiveDateTime.to_iso8601(survey.inserted_at),
        "updated_at" => NaiveDateTime.to_iso8601(survey.updated_at),
        "status" => "Active",
        "questions" => [
          %{
            "id" => question.id,
            "questionTitle" => "Pick a number between one and four",
            "options" => [
              %{"description" => "Four", "pointValue" => 4, "id" => answer_4.id},
              %{"description" => "Three", "pointValue" => 3, "id" => answer_3.id},
              %{"description" => "Two", "pointValue" => 2, "id" => answer_2.id},
              %{"description" => "One", "pointValue" => 1, "id" => answer_1.id}
            ]
          }
        ],
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
        ]
      },
      "averages" => [
        %{
          "question_id" => question.id,
          "questionTitle" => question.text,
          "average_rating" => "3.3333333333333333"
        }
      ]
    }

    assert json_response(conn, 200) == expected
  end

  test "It can return the results from a survey for a group", %{conn: conn} do
    survey = Repo.one(Survey) |> Repo.preload(:questions)
    [question] = survey.questions
    [answer_1, answer_2, answer_3, answer_4] = Repo.all(Answer)
    group = Repo.one(Group) |> Repo.preload(:users)
    [user_1, user_2, user_3] = group.users
    uri = "/api/v1/surveys/#{survey.id}/user_averages"

    conn = get(conn, uri)

    expected = %{
      "averages" => [
        %{
          "average_rating" => "3.5000000000000000",
          "question_id" => question.id,
          "user_id" => user_1.id,
          "fullName" => user_1.name
        },
        %{
          "average_rating" => "3.0000000000000000",
          "question_id" => question.id,
          "user_id" => user_2.id,
          "fullName" => user_2.name
        }
      ],
      "survey" => %{
        "created_at" => NaiveDateTime.to_iso8601(survey.inserted_at),
        "surveyExpiration" => nil,
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
        "id" => survey.id,
        "surveyName" => "Test Survey",
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
            "id" => question.id,
            "questionTitle" => "Pick a number between one and four"
          }
        ],
        "status" => "Active",
        "updated_at" => NaiveDateTime.to_iso8601(survey.updated_at)
      }
    }

    assert json_response(conn, 200) == expected
  end

  test "Averages for student returns a 401 if invalid API key", %{conn: conn} do
    survey = Repo.one(Survey) |> Repo.preload(:questions)
    uri = "/api/v1/surveys/#{survey.id}/averages/student?api_key=invalidkey"
    conn = get(conn, uri)

    assert json_response(conn, 401) == %{"error" => "Invalid API Key"}
  end

  test "It can return averages for one user", %{conn: conn} do
    survey = Repo.one(Survey) |> Repo.preload(:questions)
    [question] = survey.questions
    [answer_1, answer_2, answer_3, answer_4] = Repo.all(Answer)
    group = Repo.one(Group) |> Repo.preload(:users)
    [user_1, user_2, user_3] = group.users
    uri = "/api/v1/surveys/#{survey.id}/averages/student?api_key=#{user_1.api_key}"

    conn = get(conn, uri)

    expected = %{
      "averages" => [
        %{
          "average_rating" => "3.5000000000000000",
          "question_id" => question.id,
          "user_id" => user_1.id,
          "fullName" => user_1.name
        }
      ],
      "survey" => %{
        "created_at" => NaiveDateTime.to_iso8601(survey.inserted_at),
        "surveyExpiration" => nil,
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
        "id" => survey.id,
        "surveyName" => "Test Survey",
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
            "id" => question.id,
            "questionTitle" => "Pick a number between one and four"
          }
        ],
        "status" => "Active",
        "updated_at" => NaiveDateTime.to_iso8601(survey.updated_at)
      }
    }

    assert json_response(conn, 200) == expected
  end
end
