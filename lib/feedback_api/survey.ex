defmodule FeedbackApi.Survey do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Enum

  defenum(StatusEnum, active: 0, closed: 1, disabled: 3)

  schema "surveys" do
    field :name, :string
    field :status, StatusEnum, default: :active

    timestamps()
  end

  @doc false
  def changeset(survey, attrs) do
    survey
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
