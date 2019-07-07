defmodule FeedbackApi.Question do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__

  schema "questions" do
    field :text, :string
    belongs_to :survey, FeedbackApi.Survey
    has_many :answers, FeedbackApi.Answer
    has_many :responses, FeedbackApi.Response

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end

  def create_for_survey(survey, params, answers) do
    question = changeset(%Question{}, %{
      text: params["questionTitle"]
    })
    |> put_assoc(:answers, answers)

    put_assoc(survey, :questions, [question | survey.changes.questions])
  end
end
