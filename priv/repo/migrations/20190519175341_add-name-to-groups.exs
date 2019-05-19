defmodule :"Elixir.FeedbackApi.Repo.Migrations.Add-name-to-groups" do
  use Ecto.Migration

  def change do
    alter table(:groups) do
      add :name, :string
    end
  end
end
