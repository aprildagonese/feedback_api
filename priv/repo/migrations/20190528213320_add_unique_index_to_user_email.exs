defmodule FeedbackApi.Repo.Migrations.AddUniqueIndexToUserEmail do
  use Ecto.Migration

  def change do
    create unique_index("users", [:email])
  end
end
