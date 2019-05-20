defmodule FeedbackApi.Repo.Migrations.AddExpDateToSurvey do
  use Ecto.Migration

  def change do
    alter table(:surveys) do
      add :exp_date, :naive_datetime
    end
  end
end
