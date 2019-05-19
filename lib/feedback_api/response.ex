defmodule FeedbackApi.Response do
  use Ecto.Schema
  import Ecto.Changeset

  schema "responses" do
    field :target_user, :id
    field :response_user, :id
    field :answer_id, :id

    timestamps()
  end

  @doc false
  def changeset(response, attrs) do
    response
    |> cast(attrs, [])
    |> validate_required([])
  end
end
