defmodule Banking.Repo do
  use Ecto.Repo,
    otp_app: :banking,
    adapter: Ecto.Adapters.Postgres
end
