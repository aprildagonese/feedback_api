defmodule FeedbackApi.Repo.Migrations.CreateSurveys do
  use Ecto.Migration

  def change do
    create table(:surveys) do
      add :name, :string

      timestamps()
    end

  end
end
