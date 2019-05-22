defmodule FeedbackApi.Repo.Migrations.UpdateReferenceNamesOnResponse do
  use Ecto.Migration

  def change do
    alter table(:responses) do
      remove :target_user
      remove :response_user
      add :recipient_id, references(:users, on_delete: :nothing)
      add :reviewer_id, references(:users, on_delete: :nothing)
      
    end

    create index(:responses, [:recipient_id])
    create index(:responses, [:reviewer_id])
  end
end
