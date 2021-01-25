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

config :database, Database.Repo,
  database: "database_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"

# Configure Mix tasks and generators
config :database,
  ecto_repos: [Database.Repo]

config :rushing_web,
  generators: [context_app: :database]

config :rushing_web,
  ecto_repos: [Database.Repo]

# Configures the endpoint
config :rushing_web, RushingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "SAGBkEAtt/+GUZ0rn/NMUL2hHWEX3zq2fJ4wD+478XH6yhaQntTXRdkNHFqARFwh",
  render_errors: [view: RushingWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: RushingWeb.PubSub,
  live_view: [signing_salt: "nF6VFXE2"]

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

# Don't generate models
config :phoenix, :generators, model: false

config :phoenix, :generators, migration: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
