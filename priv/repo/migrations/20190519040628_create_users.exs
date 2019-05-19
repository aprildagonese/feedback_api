defmodule FeedbackApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :cohort_id, references(:cohorts, on_delete: :nothing)

      timestamps()
    end

    create index(:users, [:cohort_id])
  end
end
