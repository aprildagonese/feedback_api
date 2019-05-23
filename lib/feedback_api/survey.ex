defmodule FeedbackApi.Survey do
  use Ecto.Schema
  import Ecto.{Enum, Query, Changeset}
  alias FeedbackApi.{Survey, Question, User, Repo, Group}

  defenum(StatusEnum, active: 0, closed: 1, disabled: 3)

  schema "surveys" do
    field :name, :string
    field :status, StatusEnum, default: :active
    field :exp_date, :naive_datetime
    belongs_to :user, User
    has_many :groups, Group
    has_many :questions, Question

    timestamps()
  end

  @doc false
  def changeset(survey, attrs) do
    survey
    |> cast(attrs, [:name, :status, :exp_date, :user_id])
    |> validate_required([:name, :status]) # Re-add requirement following Auth
  end

  def all do
    Repo.all(
      from survey in Survey,
        left_join: groups in assoc(survey, :groups),
        left_join: users in assoc(groups, :users),
        left_join: questions in assoc(survey, :questions),
        left_join: answers in assoc(questions, :answers),
        order_by: [desc: survey.inserted_at, desc: answers.value],
        preload: [groups: {groups, users: users}, questions: {questions, answers: answers}]
    )
  end

  def one(id) do
    Repo.one(
      from survey in Survey,
        left_join: groups in assoc(survey, :groups),
        left_join: users in assoc(groups, :users),
        left_join: questions in assoc(survey, :questions),
        left_join: answers in assoc(questions, :answers),
        where: survey.id == ^id,
        order_by: [desc: survey.inserted_at, desc: answers.value],
        preload: [groups: {groups, users: users}, questions: {questions, answers: answers}]
    )
  end

  def averages(survey_id) do
    Repo.one(
      from survey in Survey,
        join: groups in assoc(survey, :groups),
        join: users in assoc(groups, :users),
        join: questions in assoc(survey, :questions),
        join: answers in assoc(questions, :answers),
        join:
          averages in subquery(
            from q2 in Question,
              join: a2 in assoc(q2, :answers),
              join: responses in assoc(a2, :responses),
              group_by: q2.id,
              select: %{id: q2.id, text: q2.text, average: avg(a2.value)}
          ),
        on: questions.id == averages.id,
        where: survey.id == ^survey_id,
        order_by: [asc: questions.id, desc: answers.value],
        select: %{survey: survey, averages: [averages]},
        preload: [groups: {groups, users: users}, questions: {questions, answers: answers}]
    )
  end

  def user_averages(survey_id) do
    Repo.all(
      from question in Question,
        left_join: responses in assoc(question, :responses),
        join: answers in assoc(responses, :answer),
        where: question.survey_id == ^survey_id,
        group_by: [question.id, responses.recipient_id],
        select: %{
          question_id: question.id,
          user_id: responses.recipient_id,
          average_rating: avg(answers.value)
        }
    )
  end
end
