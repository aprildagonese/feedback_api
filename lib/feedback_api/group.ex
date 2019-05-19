defmodule FeedbackApi.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :survey_id, :id

    timestamps()
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [])
    |> validate_required([])
  end
end
