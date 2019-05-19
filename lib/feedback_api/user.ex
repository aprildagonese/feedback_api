defmodule FeedbackApi.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :cohort_id, :id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [])
    |> validate_required([])
  end
end
