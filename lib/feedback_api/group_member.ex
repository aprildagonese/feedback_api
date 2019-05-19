defmodule FeedbackApi.GroupMember do
  use Ecto.Schema
  import Ecto.Changeset

  schema "group_members" do
    belongs_to :user, FeedbackApi.User
    belongs_to :group, FeedbackApi.Group

    timestamps()
  end

  @doc false
  def changeset(group_member, attrs) do
    group_member
    |> cast(attrs, [])
    |> validate_required([])
  end
end
