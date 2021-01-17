# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

config :database, Rushing.Database.Repo,
  database: "database_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"

# Configure Mix tasks and generators
config :database,
  ecto_repos: [Rushing.Database.Repo]

config :web_interface,
  generators: [context_app: false]

# Configures the endpoint
config :web_interface, WebInterface.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "xoiYghdOAjm3RT3CnxaB3KbpOw8pW9V4cL7TmppmQrWyZOs2NoF8GzRKbXQIBDmc",
  render_errors: [view: WebInterface.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: WebInterface.PubSub,
  live_view: [signing_salt: "WwAyNu3R"]

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
#

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
