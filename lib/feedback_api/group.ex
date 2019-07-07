defmodule FeedbackApi.Group do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__

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

  def create_for_survey(survey, group) do
    group = Group.changeset(%Group{}, group)
    |> put_assoc(:users, FeedbackApi.User.find_all_by_id(group["members_ids"]))
    
    put_assoc(survey, :groups, [group | survey.changes.groups])
  end
end
