defmodule ComboWeb.GraphQL.SessionErrorHandler do
  @moduledoc """
  Behaviour for creating error handlers for Guardian.Plug.Pipeline.
  """

  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  @doc """
  Intercepts
  """
  def auth_error(conn, {_error_type, _reason}, _opts) do
    conn |> put_private(:auth_error, :token_is_invalid_or_expired)
  end
end
