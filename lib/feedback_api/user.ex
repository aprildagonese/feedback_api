defmodule FeedbackApi.User do
  use Ecto.Schema
  import Ecto.{Enum, Changeset, Query}

  defenum(StatusEnum, active: 0, inactive: 1)

  schema "users" do
    field :name, :string
    field :program, :string
    field :status, StatusEnum
    belongs_to :cohort, FeedbackApi.Cohort
    has_many :responses, FeedbackApi.Response, foreign_key: :reviewer_id
    has_many :ratings, FeedbackApi.Response, foreign_key: :recipient_id
    has_many :surveys, FeedbackApi.Survey
    many_to_many :groups, FeedbackApi.Group, join_through: FeedbackApi.GroupMember

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :program, :status, :cohort_id])
    |> validate_required([:name, :program, :status, :cohort_id])
  end

  def authorize(api_key) do
    # Repo.one(
    #   from u in User,
    #   where: u.api_key == ^api_key
    # )
    nil
  end
end
