defmodule FeedbackApi.Cohort do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Enum

  defenum(StatusEnum, active: 0, graduated: 1, future: 3, miscellaneous: 4)

  schema "cohorts" do
    field :name, :string
    field :program, :string
    field :status, StatusEnum
    has_many :users, FeedbackApi.User

    timestamps()
  end

  @doc false
  def changeset(cohort, attrs) do
    cohort
    |> cast(attrs, [:name, :program])
    |> validate_required([:name, :program])
  end
end
