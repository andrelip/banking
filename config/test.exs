use Mix.Config

config :banking, Banking.Repo,
  username: System.get_env("PG_USER", "postgres"),
  password: System.get_env("PG_PASSWORD", "postgres"),
  database: "banking_test",
  hostname: System.get_env("PG_HOSTNAME", "localhost"),
  pool: Ecto.Adapters.SQL.Sandbox

config :banking, BankingWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8
