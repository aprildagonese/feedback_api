defmodule FeedbackApi.Repo.Migrations.CreateCohorts do
  use Ecto.Migration

  def change do
    create table(:cohorts) do
      add :name, :string
      add :program, :string

      timestamps()
    end
  end
end
