defmodule FeedbackApi.User do
  use Ecto.Schema
  import Ecto.{Enum, Changeset, Query}
  alias FeedbackApi.{User, Repo}

  defenum(StatusEnum, Active: 0, Inactive: 1)
  defenum(RoleEnum, Student: 0, Instructor: 1)

  schema "users" do
    field :name, :string
    field :program, :string
    field :status, StatusEnum, default: 0
    field :email, :string
    field :password, :string
    field :api_key, :string
    field :role, RoleEnum, default: 0
    belongs_to :cohort, FeedbackApi.Cohort
    has_many :responses, FeedbackApi.Response, foreign_key: :reviewer_id
    has_many :ratings, FeedbackApi.Response, foreign_key: :recipient_id
    # has_many :surveys, FeedbackApi.Survey
    many_to_many :groups, FeedbackApi.Group, join_through: FeedbackApi.GroupMember
    many_to_many :surveys, FeedbackApi.User, join_through: FeedbackApi.SurveyOwner

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :program, :status, :cohort_id, :email, :password, :api_key, :role])
    |> validate_required([:name, :status, :role])
  end

  def authorize_instructor(api_key) do
    case api_key do
      nil ->
        nil

      api_key ->
        Repo.one(
          from u in User,
            where: u.api_key == ^api_key,
            where: u.role == ^:Instructor
        )
        |> Repo.preload([:surveys, :groups])
    end
  end

  def authorize_student(api_key) do
    case api_key do
      nil ->
        nil

      api_key ->
        Repo.one(
          from u in User,
            where: u.api_key == ^api_key,
            where: u.role == ^:Student
        )
        |> Repo.preload([:surveys, :groups])
    end
  end

  def active_students do
    Repo.all(
      from u in User,
        join: cohorts in assoc(u, :cohort),
        where: u.role == ^:Student,
        order_by: [asc: u.id],
        preload: [cohort: cohorts]
    )
  end

  def by_program(program) do
    Repo.all(
      from u in User,
        join: cohorts in assoc(u, :cohort),
        where: u.program == ^String.upcase(program),
        where: u.status == ^:Active,
        order_by: [asc: u.id],
        preload: [cohort: cohorts]
    )
  end

  def by_cohort(cohort) do
    Repo.all(
      from u in User,
        join: cohorts in assoc(u, :cohort),
        where: cohorts.name == ^cohort,
        where: u.status == ^:Active,
        order_by: [asc: u.id],
        preload: [cohort: cohorts]
    )
  end

  def by_program_and_cohort(program, cohort) do
    Repo.all(
      from u in User,
        join: cohorts in assoc(u, :cohort),
        where: cohorts.name == ^cohort,
        where: u.program == ^String.upcase(program),
        where: u.status == ^:Active,
        order_by: [asc: u.id],
        preload: [cohort: cohorts]
    )
  end
end
