defmodule FeedbackApi.Repo do
  use Ecto.Repo,
    otp_app: :feedback_api,
    adapter: Ecto.Adapters.Postgres
end
