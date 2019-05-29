defmodule FeedbackApi.Repo.Migrations.AddDefaultEnumValues do
  use Ecto.Migration

  def change do
    alter table(:surveys) do
      modify :status, :integer, default: 0, null: false
    end

    alter table(:users) do
      modify :status, :integer, default: 0, null: false
      modify :role, :integer, default: 0, null: false
    end
  end
end
