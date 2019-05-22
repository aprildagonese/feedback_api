defmodule FeedbackApi.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias FeedbackApi.{User, Repo}

  schema "users" do
    field :name, :string
    field :program, :string
    belongs_to :cohort, FeedbackApi.Cohort
    has_many :responses, FeedbackApi.Response, foreign_key: :reviewer_id
    has_many :ratings, FeedbackApi.Response, foreign_key: :recipient_id
    many_to_many :groups, FeedbackApi.Group, join_through: FeedbackApi.GroupMember

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :program])
    |> validate_required([:name, :program])
  end

  def all_with_cohort do
    Repo.all(
      from u in User,
        join: cohort in assoc(u, :cohort),
        preload: [cohort: cohort]
    )
  end
end
