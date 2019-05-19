defmodule FeedbackApi.Repo.Migrations.CreateResponses do
  use Ecto.Migration

  def change do
    create table(:responses) do
      add :target_user, references(:users, on_delete: :nothing)
      add :response_user, references(:users, on_delete: :nothing)
      add :answer_id, references(:answers, on_delete: :nothing)

      timestamps()
    end

    create index(:responses, [:target_user])
    create index(:responses, [:response_user])
    create index(:responses, [:answer_id])
  end
end
