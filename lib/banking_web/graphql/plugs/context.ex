defmodule BankingWeb.GraphQL.Plugs.Context do
  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  def build_context(conn) do
    case Guardian.Plug.current_resource(conn) do
      nil ->
        %{}

      current_user ->
        %{current_user: current_user}
    end
  end
end
