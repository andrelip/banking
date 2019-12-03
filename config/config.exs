use Mix.Config

config :banking,
  ecto_repos: [Banking.Repo]

config :banking, BankingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ain0iXiTpvZ/h4ks3EHrGZ21F8m8li05kidoJ2NY9pPrZNAwFje8i+8QfdBvDy5S",
  render_errors: [view: BankingWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Banking.PubSub, adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :argon2_elixir,
  t_cost: 8,
  m_cost: 17,
  argon_type: 2

config :banking, :environment, Mix.env()

config :banking, Banking.Session.Guardian,
  issuer: "banking",
  ttl: {2, :days},
  secret_key: "/uHX/oQ4CmwgGTR0u+adav4dmj4mk+aKJ/nyNWH0P0RhJLyrAfLJtBhB2m2P7I/z"

import_config "#{Mix.env()}.exs"
