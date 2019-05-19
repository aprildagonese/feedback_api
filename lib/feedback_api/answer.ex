defmodule FeedbackApi.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "answers" do
    field :description, :string
    field :value, :integer
    field :question_id, :id

    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:description, :value])
    |> validate_required([:description, :value])
  end
end
