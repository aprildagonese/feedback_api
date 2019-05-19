defmodule FeedbackApi.Repo.Migrations.AddStatusToSurveys do
  use Ecto.Migration

  def change do
    alter table(:surveys) do
      add :status, :integer
    end
  end
end
