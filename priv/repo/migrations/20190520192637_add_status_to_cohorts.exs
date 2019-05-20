defmodule FeedbackApi.Repo.Migrations.AddStatusToCohorts do
  use Ecto.Migration

  def change do
    adjust table(:cohorts) do
      add :status, :integer
    end
  end
end
