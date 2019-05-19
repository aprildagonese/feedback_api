defmodule FeedbackApi.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :text, :string
    field :survey_id, :id

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
