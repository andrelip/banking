defmodule BankingWeb.GraphQL.Plugs.Context do
  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  def build_context(conn) do
    remote_ip = conn.remote_ip |> :inet_parse.ntoa() |> to_string()

    case Guardian.Plug.current_resource(conn) do
      nil ->
        %{remote_ip: remote_ip}

      current_user ->
        %{current_user: current_user, remote_ip: remote_ip}
    end
  end
end
