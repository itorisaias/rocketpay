use Mix.Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :rocketpay, Rocketpay.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :rocketpay, RocketpayWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

guardian_secrety_key =
  System.get_env("GUARDIAN_SECRET_KEY") ||
    raise """
    environment variable GUARDIAN_SECRET_KEY is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :rocketpay, RocketpayInfra.Guardian,
  issuer: "rocketpay",
  secret_key: guardian_secrety_key

mailer_hostname =
  System.get_env("MAILER_HOSTNAME") ||
    raise """
    environment variable MAILER_HOSTNAME is missing.
    """

mailer_username =
  System.get_env("MAILER_USERNAME") ||
    raise """
    environment variable MAILER_USERNAME is missing.
    """

mailer_password =
  System.get_env("MAILER_PASSWORD") ||
    raise """
    environment variable MAILER_PASSWORD is missing.
    """

config :rocketpay, RocketpayInfra.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: mailer_hostname,
  hostname: mailer_hostname,
  port: String.to_integer(System.get_env("MAILER_PORT") || 587),
  username: mailer_username,
  password: mailer_password,
  tls: :if_available,
  allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"],
  ssl: false,
  retries: 1,
  no_mx_lookups: false,
  auth: :if_available

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :rocketpay, RocketpayWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
