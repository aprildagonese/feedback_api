defmodule FeedbackApi.Question do
  use Ecto.Schema
  import Ecto.Changeset

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
end
