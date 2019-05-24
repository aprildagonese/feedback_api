defmodule FeedbackApi.User do
  use Ecto.Schema
  import Ecto.{Enum, Changeset, Query}
  alias FeedbackApi.{User, Repo}

  defenum(StatusEnum, Active: 0, Inactive: 1)
  defenum(RoleEnum, Student: 0, Instructor: 1)

  schema "users" do
    field :name, :string
    field :program, :string
    field :status, StatusEnum
    field :email, :string
    field :password, :string
    field :api_key, :string
    field :role, RoleEnum
    belongs_to :cohort, FeedbackApi.Cohort
    has_many :responses, FeedbackApi.Response, foreign_key: :reviewer_id
    has_many :ratings, FeedbackApi.Response, foreign_key: :recipient_id
    has_many :surveys, FeedbackApi.Survey
    many_to_many :groups, FeedbackApi.Group, join_through: FeedbackApi.GroupMember

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :program, :status, :cohort_id, :email, :password, :api_key, :role])
    |> validate_required([:name, :program, :status, :cohort_id])
  end

  def authorize(api_key) do
    case api_key do
      nil -> nil
      api_key -> Repo.one(
        from u in User,
        where: u.api_key == ^api_key
      )
    end

  end
end
