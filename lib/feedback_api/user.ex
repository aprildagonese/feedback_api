defmodule FeedbackApi.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    belongs_to :cohort, FeedbackApi.Cohort
    has_many :responses, FeedbackApi.Response, foreign_key: :response_user
    has_many :ratings, FeedbackApi.Response, foreign_key: :target_user
    many_to_many :groups, FeedbackApi.Group, join_through: FeedbackApi.GroupMember

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [])
    |> validate_required([])
  end
end
