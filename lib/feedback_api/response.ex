defmodule FeedbackApi.Response do
  use Ecto.Schema
  import Ecto.Changeset

  schema "responses" do
    belongs_to :answer, FeedbackApi.Answer
    belongs_to :reviewer, FeedbackApi.User
    belongs_to :recipient, FeedbackApi.User

    timestamps()
  end

  @doc false
  def changeset(response, attrs) do
    response
    |> cast(attrs, [])
    |> validate_required([])
  end
end
