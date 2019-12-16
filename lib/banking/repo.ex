defmodule Banking.Repo do
  @moduledoc """
  The repository to interact with the PostgreSQL database used in the Banking Application.
  """

  use Ecto.Repo,
    otp_app: :banking,
    adapter: Ecto.Adapters.Postgres
end
