defmodule ComboWeb.GraphQL.SessionErrorHandler do
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_error_type, _reason}, _opts) do
    response = build_error_response("Session invalid or expired", 401, :invalid_token)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, response)
    |> halt()
  end

  def build_error_response(message, code, status_code) do
    extensions = %{code: code, status_code: status_code}
    errors = [%{message: message, extensions: extensions}]

    Map.put(%{}, :errors, errors)
    |> Jason.encode!()
  end
end
