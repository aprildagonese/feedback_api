defmodule FeedbackApi.SurveyOwner do
  use Ecto.Schema
  import Ecto.Changeset

  schema "survey_owners" do
    belongs_to :survey, FeedbackApi.Survey
    belongs_to :user, FeedbackApi.User

    timestamps()
  end

  @doc false
  def changeset(survey_owner, attrs) do
    survey_owner
    |> cast(attrs, [])
    |> validate_required([])
  end
end
