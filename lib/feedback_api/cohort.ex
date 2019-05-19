defmodule FeedbackApi.Cohort do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cohorts" do
    field :name, :string
    field :program, :string

    timestamps()
  end

  @doc false
  def changeset(cohort, attrs) do
    cohort
    |> cast(attrs, [:name, :program])
    |> validate_required([:name, :program])
  end
end
