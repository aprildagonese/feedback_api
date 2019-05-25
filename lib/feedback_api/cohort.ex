defmodule FeedbackApi.Cohort do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Enum

  defenum(StatusEnum, Active: 0, Graduated: 1, Future: 3, Miscellaneous: 4)

  schema "cohorts" do
    field :name, :string
    field :status, StatusEnum, default: 0
    has_many :users, FeedbackApi.User

    timestamps()
  end

  @doc false
  def changeset(cohort, attrs) do
    cohort
    |> cast(attrs, [:name, :status])
    |> validate_required([:name, :status])
  end
end
