defmodule FeedbackApi.Repo.Migrations.AddStatusToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :status, :integer
    end
  end
end
