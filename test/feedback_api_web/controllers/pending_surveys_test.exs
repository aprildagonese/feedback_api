defmodule FeedbackApiWeb.PendingSurveysTest do
  use FeedbackApiWeb.ConnCase
  alias FeedbackApi.{Cohort, Group, Survey, Question, User, Repo}

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

    :ok
  end

  test "Returns surveys pending for a user", %{conn: conn} do
    survey = Repo.one(Survey)
    question = Repo.one(Question)
    group = Repo.one(Group) |> Repo.preload(:users)
    [user_1, user_2, user_3] = group.users

    uri = "/api/v1/surveys/pending?api_key=#{user_1.api_key}"

    conn = get(conn, uri)

    expected = [
      %{
        "groups" => [
          %{
            "member_ids" => [user_2.id, user_3.id],
            "name" => "Test"
          }
        ],
        "surveyName" => "Test Survey",
        "id" => survey.id,
        "surveyExpiration" => nil,
        "created_at" => NaiveDateTime.to_iso8601(survey.inserted_at),
        "updated_at" => NaiveDateTime.to_iso8601(survey.updated_at),
        "questions" => [
          %{
            "options" => [
              %{
                "description" => "Four",
                "pointValue" => 4
              },
              %{
                "description" => "Three",
                "pointValue" => 3
              },
              %{
                "description" => "Two",
                "pointValue" => 2
              },
              %{
                "description" => "One",
                "pointValue" => 1
              }
            ],
            "id" => question.id,
            "questionTitle" => "Pick a number between one and four"
          }
        ],
        "status" => "active"
      }
    ]

    assert json_response(conn, 200) == expected

  end

  test "Returns an empty list for users with no pending surveys", %{conn: conn} do
    [_user_1, user_2, _user_3] = Repo.all(User)
    uri = "/api/v1/surveys/pending?api_key=#{user_2.api_key}"
    conn = get(conn, uri)

    assert json_response(conn, 200) == []
  end

  test "Returns a 401 if key is invalid", %{conn: conn} do
    uri = "/api/v1/surveys/pending?api_key=fakeapikey"
    conn = get(conn, uri)

    assert json_response(conn, 401) == %{"error" => "Invalid API Key"}
  end
end
