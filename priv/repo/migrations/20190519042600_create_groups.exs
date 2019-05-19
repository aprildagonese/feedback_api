defmodule FeedbackApi.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :survey_id, references(:surveys, on_delete: :nothing)

      timestamps()
    end

    create index(:groups, [:survey_id])
  end
end
