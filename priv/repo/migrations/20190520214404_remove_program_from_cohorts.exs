defmodule FeedbackApi.Repo.Migrations.RemoveProgramFromCohorts do
  use Ecto.Migration

  def change do
    alter table(:cohorts) do
      remove :program
    end
  end
end
