defmodule FeedbackApi.Repo.Migrations.AddQuestionReferencesToResponses do
  use Ecto.Migration

  def change do
    alter table(:responses) do
      add :question_id, references(:questions, on_delete: :nothing)
    end

    create index(:responses, [:question_id])
  end
end
