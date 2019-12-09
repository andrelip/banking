import Config

config :banking, Banking.Repo,
  username: System.get_env("PG_USERNAME", "postgres"),
  password: System.get_env("PG_PASSWORD", "postgres"),
  database: System.get_env("PG_DATABASE", "banking_prod"),
  hostname: System.get_env("PG_HOSTNAME", "postgres"),
  show_sensitive_data_on_connection_error: true,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

guardian_secret_key =
  System.get_env("GUARDIAN_SECRET_KEY") ||
    raise """
    environment variable GUARDIAN_SECRET_KEY is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :banking, BankingWeb.Endpoint,
  http: [:inet6, port: String.to_integer(System.get_env("PORT") || "4000")],
  secret_key_base: secret_key_base,
  server: true

config :banking, Banking.Session.Guardian,
  issuer: "banking",
  ttl: {2, :days},
  secret_key: guardian_secret_key

banking_domain =
  System.get_env("BANKING_DOMAIN") ||
    raise """
    Specify the hostname of the banking app
    """

config :banking, BankingWeb.Endpoint,
  url: [host: banking_domain, port: String.to_integer(System.get_env("HTTP_PORT") || "4000")],
  cache_static_manifest: "priv/static/cache_manifest.json",
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  http: [port: String.to_integer(System.get_env("HTTP_PORT") || "4000")],
  https: [
    port: String.to_integer(System.get_env("HTTPS_PORT") || "4001"),
    otp_app: :banking,
    keyfile: System.get_env("BANKING_SSL_KEY_PATH"),
    certfile: System.get_env("BANKING_SSL_CERT_PATH"),
    cacertfile: System.get_env("BANKING_INTERMEDIATE_CERTFILE_PATH"),
    compress: true
  ]

sender_email =
  System.get_env("BANKING_SUPPORT_EMAIL") ||
    raise """
    Specify the support sender key with the env BANKING_SUPPORT_EMAIL
    """

send_api_key =
  System.get_env("SENDGRID_API_KEY") ||
    raise """
    Specify the sendgrid API KEY or edit releases.exs to fit your needs
    """

config :banking, Banking.Mailer,
  adapter: Bamboo.SendGridAdapter,
  support_email: sender_email,
  api_key: send_api_key
