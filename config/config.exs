# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :rocketpay,
  ecto_repos: [Rocketpay.Repo]

# Configures the endpoint
config :rocketpay, RocketpayWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LWu7upy6L0qI7BdAX6uoiOsPEh/husNyVgAtP77+67WvRnPeEnLOHbMUcuv0oRGO",
  render_errors: [view: RocketpayWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Rocketpay.PubSub,
  live_view: [signing_salt: "icG11wYj"]

config :rocketpay, Rocketpay.Repo,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binary_id]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# config :rocketpay, :basic_auth,
#   username: "banana", # System.get_env("USERNAME")
#   password: "naninca123" # System.get_env("USERNAME")

config :rocketpay, RocketpayInfra.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.ethereal.email",
  hostname: "smtp.ethereal.email",
  port: 587,
  username: "constantin.ernser@ethereal.email",
  password: "EdtdD8m8FjashqE8fY",
  tls: :if_available,
  allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"],
  ssl: false,
  retries: 1,
  no_mx_lookups: false,
  auth: :if_available

config :rocketpay, RocketpayInfra.Guardian,
  issuer: "rocketpay",
  secret_key: "yJOavDfJNezRx0QTW9t1IpXxPgDmAC0IMBlBLjyUpn80cFYnox8IFEfIqIuAHZqV"

# System.get_env("GUARDIAN_SECRET_KEY")

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
