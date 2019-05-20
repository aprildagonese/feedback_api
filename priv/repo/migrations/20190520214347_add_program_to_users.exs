defmodule FeedbackApi.Repo.Migrations.AddProgramToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :program, :string
    end
  end
end
