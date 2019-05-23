defmodule FeedbackApi.Repo.Migrations.AddUseridToSurveys do
  use Ecto.Migration

  def change do
    alter table(:surveys) do
      add :user_id, references(:users, on_delete: :nothing)
    end

    create index(:surveys, [:user_id])
  end
end
