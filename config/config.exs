use Mix.Config

config :rocketpay,
  ecto_repos: [Rocketpay.Repo]

config :rocketpay, RocketpayWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LWu7upy6L0qI7BdAX6uoiOsPEh/husNyVgAtP77+67WvRnPeEnLOHbMUcuv0oRGO",
  render_errors: [view: RocketpayWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Rocketpay.PubSub,
  live_view: [signing_salt: "icG11wYj"]

config :rocketpay, Rocketpay.Repo,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binary_id]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :rocketpay, RocketpayInfra.Guardian,
  issuer: "rocketpay",
  secret_key: "yJOavDfJNezRx0QTW9t1IpXxPgDmAC0IMBlBLjyUpn80cFYnox8IFEfIqIuAHZqV"

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
