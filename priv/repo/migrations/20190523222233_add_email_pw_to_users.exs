defmodule FeedbackApi.Repo.Migrations.AddEmailPwToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :email, :string
      add :password, :string
      add :api_key, :string
      add :role, :integer
    end
  end
end
