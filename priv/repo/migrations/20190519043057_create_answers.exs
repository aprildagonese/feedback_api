defmodule FeedbackApi.Repo.Migrations.CreateAnswers do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :description, :string
      add :value, :integer
      add :question_id, references(:questions, on_delete: :nothing)

      timestamps()
    end

    create index(:answers, [:question_id])
  end
end
