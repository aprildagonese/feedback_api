use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :feedback_api, FeedbackApi.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test
config :logger, level: :debug

# Configure your database
config :feedback_api, FeedbackApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "",
  database: "feedback_api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
