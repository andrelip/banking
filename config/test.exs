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

config :banking, Banking.Mailer,
  support_email: "support@test.com.br",
  adapter: Bamboo.TestAdapter

config :banking, Banking.Admin,
  key_hash:
    "$argon2id$v=19$m=256,t=1,p=4$D38eLWVwEWdMlBUxlbAo7g$CrhYBh5hYcbVMnh36s8VWP/jCAqstxxetJJPcpzRSuY"
