defmodule BankingWeb.GraphQL.Plugs.Context do
  @moduledoc """
  Prepares the context in order to allow Absinthe to handle authentication and
  authorization
  """

  @behaviour Plug

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  defp build_context(conn) do
    remote_ip = conn.remote_ip |> :inet_parse.ntoa() |> to_string()
    auth_error = conn.private[:auth_error]

    case {Guardian.Plug.current_resource(conn), auth_error} do
      {nil, nil} ->
        %{remote_ip: remote_ip}

      {nil, :token_is_invalid_or_expired} ->
        %{remote_ip: remote_ip, auth_error: "token is invalid or has expired"}

      {current_user, _} ->
        %{current_user: current_user, remote_ip: remote_ip}
    end
  end
end
