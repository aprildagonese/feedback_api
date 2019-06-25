defmodule FeedbackApi.Repo.Migrations.CreateSurveyOwners do
  use Ecto.Migration

  def change do
    create table(:survey_owners) do
      add :survey_id, references(:surveys, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:survey_owners, [:survey_id])
    create index(:survey_owners, [:user_id])
  end
end
