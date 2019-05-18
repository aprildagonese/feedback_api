# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :feedback_api,
  ecto_repos: [FeedbackApi.Repo]

# Configures the endpoint
config :feedback_api, FeedbackApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aVmbX8tVSXSzb/2M9xDEZbdu2UJPqI2JJstj3g+aDj8ahxvUhL0irqvtch3EbMky",
  render_errors: [view: FeedbackApiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: FeedbackApi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
