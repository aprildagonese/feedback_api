defmodule FeedbackApi.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "answers" do
    field :description, :string
    field :value, :integer
    belongs_to :question, FeedbackApi.Question
    has_many :responses, FeedbackApi.Response

    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:description, :value])
    |> validate_required([:description, :value])
  end
end
