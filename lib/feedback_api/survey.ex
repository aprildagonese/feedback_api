defmodule FeedbackApi.Survey do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Enum

  defenum(StatusEnum, active: 0, closed: 1, disabled: 3)

  schema "surveys" do
    field :name, :string
    field :status, StatusEnum, default: :active
    field :exp_date, :naive_datetime
    has_many :groups, FeedbackApi.Group
    has_many :questions, FeedbackApi.Question

    timestamps()
  end

  @doc false
  def changeset(survey, attrs) do
    survey
    |> cast(attrs, [:name, :status, :exp_date])
    |> validate_required([:name, :status])
  end
end
