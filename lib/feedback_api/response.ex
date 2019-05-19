defmodule FeedbackApi.Response do
  use Ecto.Schema
  import Ecto.Changeset

  schema "responses" do
    field :target_user, :id
    field :response_user, :id
    belongs_to :answer, FeedbackApi.Answer
    belongs_to :reviewer, FeedbackApi.User, define_field: :target_user
    belongs_to :recipient, FeedbackApi.User, define_field: :response_user

    timestamps()
  end

  @doc false
  def changeset(response, attrs) do
    response
    |> cast(attrs, [])
    |> validate_required([])
  end
end
