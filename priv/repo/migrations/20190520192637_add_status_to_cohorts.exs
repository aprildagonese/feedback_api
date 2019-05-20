defmodule FeedbackApi.Repo.Migrations.AddStatusToCohorts do
  use Ecto.Migration

  def change do
    alter table(:cohorts) do
      add :status, :integer
    end
  end
end
