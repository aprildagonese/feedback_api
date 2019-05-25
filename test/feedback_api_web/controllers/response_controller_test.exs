defmodule FeedbackApiWeb.ResponseController do
  use FeedbackApiWeb.ConnCase
  alias FeedbackApi.{Cohort, Survey, User, Question, Repo, Answer}
  import Ecto.Query

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
        |> Repo.preload([:responses, :ratings, :surveys])
      end)

    # User_1 : 3.5, User_2 : 3, User_3 : nil
    [_user_1, _user_2, user_3] = users

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

    Enum.map(answer_list, fn answer ->
      Ecto.build_assoc(question, :answers, answer) |> Repo.insert!()
    end)

    :ok
  end

  test "Returns a 401 if API key not provided", %{conn: conn} do
    [_user_1, user_2, user_3] = Repo.all(User)
    question = Repo.one(Question)
    answer = Repo.one(from a in Answer, where: a.value == 4)
    conn = conn |> put_req_header("content-type", "application/json")
    body =  %{
      responses: [
        %{question: question.id, answer: answer.id, recipient: user_2.id},
        %{question: question.id, answer: answer.id, recipient: user_3.id}
      ]
    }

    post(conn, "/api/v1/responses", body)

    assert json_response(conn, 401) == %{"error" => "Invalid API Key"}
  end

  test "Returns a 422 if the response is invalid", %{conn: conn} do
    [user_1, _user_2, _user_3] = Repo.all(User)
    conn = conn |> put_req_header("content-type", "application/json")
    body =  %{api_key: user_1.api_key}

    post(conn, "/api/v1/responses", body)

    assert json_response(conn, 422) == %{"error" => "Invalid format"}
  end

  test "Users can create responses", %{conn: conn} do
    [user_1, user_2, user_3] = Repo.all(User)
    question = Repo.one(Question)
    answer = Repo.one(from a in Answer, where: a.value == 4)
    conn = conn |> put_req_header("content-type", "application/json")
    body =  %{
      api_key: user_1.api_key,
      responses: [
        %{question: question.id, answer: answer.id, recipient: user_2.id},
        %{question: question.id, answer: answer.id, recipient: user_3.id}
      ]
    }

    post(conn, "/api/v1/responses", body)

    assert json_response(conn, 201) == %{"sucess" => "Responses have been stored"}
    assert Repo.one(from r in Response, select: count(r.id)) == 2
  end
end
