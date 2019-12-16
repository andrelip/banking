defmodule Banking.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Banking.Repo,
      BankingWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Banking.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    BankingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
