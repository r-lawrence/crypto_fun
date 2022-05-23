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
# config :binance, Binance.API, binance_service: Binance.API
# Configure Mix tasks and generators
config :binance,
  ecto_repos: [CryptoEngine.Repo]

config :binance, Binance.API,
  binance_service: Binance.API


###
config :crypto_engine,
  ecto_repos: [CryptoEngine.Repo]

# Configures the endpoint
# config :crypto_api, CryptoApiWeb.Endpoint,
#   url: [host: "localhost"],
#   render_errors: [view: CryptoApiWeb.ErrorView, accepts: ~w(json), layout: false],
#   pubsub_server: CryptoApi.PubSub,
#   live_view: [signing_salt: "nLM1BoHy"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
# config :crypto_api, CryptoApi.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
# config :swoosh, :api_client, false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason






# Configures the endpoint
config :crypto_web, CryptoWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: CryptoWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: CryptoEngine.PubSub,
  live_view: [signing_salt: "AWC/Uy6a"]

  config :crypto_web, CryptoEngine.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/crypto_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
