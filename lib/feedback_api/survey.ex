defmodule FeedbackApi.Survey do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Enum
  alias FeedbackApi.{User, Group, Question}

  defenum(StatusEnum, active: 0, closed: 1, disabled: 3)

  schema "surveys" do
    field :name, :string
    field :status, StatusEnum, default: :active
    field :exp_date, :naive_datetime
    belongs_to :user, User
    has_many :groups, Group
    has_many :questions, Question

    timestamps()
  end

  @doc false
  def changeset(survey, attrs) do
    survey
    |> cast(attrs, [:name, :status, :exp_date, :user_id])
    |> validate_required([:name, :status, :user_id])
  end
end
