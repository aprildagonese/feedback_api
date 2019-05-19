defmodule FeedbackApi.GroupMember do
  use Ecto.Schema
  import Ecto.Changeset

  schema "group_members" do
    field :user_id, :id
    field :group_id, :id

    timestamps()
  end

  @doc false
  def changeset(group_member, attrs) do
    group_member
    |> cast(attrs, [])
    |> validate_required([])
  end
end
