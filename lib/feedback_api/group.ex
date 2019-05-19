defmodule FeedbackApi.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :name, :string
    belongs_to :survey, FeedbackApi.Survey
    many_to_many :users, FeedbackApi.User, join_through: FeedbackApi.GroupMember

    timestamps()
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
