defmodule FeedbackApiWeb.SurveyResponseAveragesTest do
  use FeedbackApiWeb.ConnCase
  alias FeedbackApi.{Cohort, User, Survey, Question, Answer, Response, Repo}

  setup do
    survey = %Survey{name: "Test Survey"} |> Repo.insert!() |> Repo.preload([:groups, :questions])
    cohort = %Cohort{name: "1811"} |> Repo.insert!() |> Repo.preload(:users)
    students = [
      %{name: "User 1", program: "B"},
      %{name: "User 2", program: "B"},
      %{name: "User 3", program: "B"}
    ]
    users = Enum.map(students, fn student -> Ecto.build_assoc(cohort, :users, student) |> Repo.preload([:ratings]) end)
    group = Ecto.build_assoc(survey, :groups, %{name: "Test"}) |> Repo.insert!() |> Repo.preload([:users, :survey])
    Ecto.Changeset.put_assoc(Ecto.Changeset.change(group), :users, users) |> Repo.update!()
    question = Ecto.build_assoc(survey, :questions, %{text: "Pick a number between one and four"}) |> Repo.insert! |> Repo.preload(:answers)
    answer_list = [
      %{description: "One", value: 1},
      %{description: "Two", value: 2},
      %{description: "Three", value: 3},
      %{description: "Four", value: 4}
    ]
    [answer_1, answer_2, answer_3, answer_4] = Enum.map(answer_list, fn answer -> Ecto.build_assoc(question, :answers, answer) |> Repo.insert!() end)
    [user_1, user_2, user_3] = users # User_1 : 3.5, User_2 : 3, User_3 : nil
    response_1 = Ecto.build_assoc(answer_4, :responses, %{}) |> Repo.insert!() |> Repo.preload([:reviewer, :recipient, :answer])
    Ecto.Changeset.put_assoc(Ecto.Changeset.change(response_1), :recipient, user_1) |> Repo.update!()
    Ecto.Changeset.put_assoc(Ecto.Changeset.change(response_1), :reviewer, user_3) |> Repo.update!()
    response_2 = Ecto.build_assoc(answer_3, :responses, %{}) |> Repo.insert!() |> Repo.preload([:reviewer, :recipient, :answer])
    Ecto.Changeset.put_assoc(Ecto.Changeset.change(response_2), :recipient, user_1) |> Repo.update!()
    Ecto.Changeset.put_assoc(Ecto.Changeset.change(response_2), :reviewer, user_2) |> Repo.update!()
    response_3 = Ecto.build_assoc(answer_3, :responses, %{}) |> Repo.insert!() |> Repo.preload([:reviewer, :recipient, :answer])
    Ecto.Changeset.put_assoc(Ecto.Changeset.change(response_3), :recipient, user_2) |> Repo.update!()
    Ecto.Changeset.put_assoc(Ecto.Changeset.change(response_3), :reviewer, user_1) |> Repo.update!()
    :ok
  end

  test "It can return the results from a survey for all groups", %{conn: conn} do
    import IEx; IEx.pry()
    survey = Repo.one(Survey)
    uri = "/api/v1/surveys#{survey.id}/averages"

    conn = get(conn, uri)

    expected = %{
      "id" => survey.id,
      "name" => survey.name,
      "exp_date" => nil,
      "created_at" => NaiveDateTime.to_iso8601(survey.inserted_at),
      "updated_at" => NaiveDateTime.to_iso8601(survey.updated_at),
      "status" => "active",
      "questions" => [
        %{
          "text" => "Pick a number between one and four",
          "average_rating" => 3.25,
          "answers" => [
              %{"description" => "One", "value" => 1},
              %{"description" => "Two", "value" => 2},
              %{"description" => "Three", "value" => 3},
              %{"description" => "Four", "value" => 4}
          ]
        }
      ]
    }

    assert json_response(conn, 200) == expected

  end

  test "It can return the results from a survey for a group", %{conn: conn} do
    survey = Repo.one(Survey) |> Repo.preload(:questions)
    [question] = survey.questions
    group = Repo.one(Group) |> Repo.preload([:users])
    [user_1, user_2, user_3, user_4] = group.users
    uri = "/api/v1/surveys#{survey.id}/averages/#{group.id}"

    conn = get(conn, uri)

    expected = %{
      "id" => survey.id,
      "name" => survey.name,
      "exp_date" => nil,
      "created_at" => NaiveDateTime.to_iso8601(survey.inserted_at),
      "updated_at" => NaiveDateTime.to_iso8601(survey.updated_at),
      "status" => "active",
      "questions" => [
        %{
          "text" => "Pick a number between one and four",
          "answers" => [
              %{"description" => "One", "value" => 1},
              %{"description" => "Two", "value" => 2},
              %{"description" => "Three", "value" => 3},
              %{"description" => "Four", "value" => 4}
          ]
        }
      ],
      "groups" => [
        %{
          "id" => group.id,
          "name" => "Test",
          "members" => [
            %{
              "id" => user_1.id,
              "name" => user_1.name,
              "questions" => [
                %{
                  "id" => question.id,
                  "text" => question.text,
                  "average_rating" => 3.5
                }
              ]
            },
            %{
              "id" => user_2.id,
              "name" => user_2.name,
              "questions" => [
                %{
                  "id" => question.id,
                  "text" => question.text,
                  "average_rating" => 3
                }
              ]
            },
            %{
              "id" => user_3.id,
              "name" => user_3.name,
              "questions" => [
                %{
                  "id" => question.id,
                  "text" => question.text,
                  "average_rating" => nil
                }
              ]
            }
          ]
        }
      ]
    }

    assert json_response(conn, 200) == expected
  end
end
