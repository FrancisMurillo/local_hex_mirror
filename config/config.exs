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

# Configure Mix tasks and generators
config :local_hex,
  ecto_repos: [LocalHex.Repo]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :local_hex, LocalHex.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

config :local_hex_web,
  ecto_repos: [LocalHex.Repo],
  generators: [context_app: :local_hex]

# Configures the endpoint
config :local_hex_web, LocalHexWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: LocalHexWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: LocalHex.PubSub,
  live_view: [signing_salt: "qkDk1WUe"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
