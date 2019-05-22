defmodule FeedbackApi.Survey do
  use Ecto.Schema
  import Ecto.{Enum, Query, Changeset}
  alias FeedbackApi.{Survey, Question, Repo}

  defenum(StatusEnum, active: 0, closed: 1, disabled: 3)

  schema "surveys" do
    field :name, :string
    field :status, StatusEnum, default: :active
    field :exp_date, :naive_datetime
    has_many :groups, FeedbackApi.Group
    has_many :questions, FeedbackApi.Question

    timestamps()
  end

  @doc false
  def changeset(survey, attrs) do
    survey
    |> cast(attrs, [:name, :status, :exp_date])
    |> validate_required([:name, :status])
  end

  def class_averages(survey_id) do
    Repo.one(
      from survey in Survey,
      join: questions in assoc(survey, :questions),
      join: answers in assoc(questions, :answers),
      join: averages in subquery(
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
      preload: [questions: {questions, answers: answers}]
    )
  end

  def group_averages(survey_id, group_id) do

  end
end
