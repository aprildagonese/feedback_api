defmodule FeedbackApi.Survey do
  use Ecto.Schema
  import Ecto.Changeset

  schema "surveys" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(survey, attrs) do
    survey
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
