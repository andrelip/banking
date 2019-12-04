defmodule ComboWeb.GraphQL.SessionErrorHandler do
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {:invalid_token, _reason}, _opts) do
    response = build_error_response("Session expired or invalid", 401, :invalid_token)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response)
  end

  def auth_error(conn, {type, _reason}, _opts) do
    body = to_string(type)

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(401, body)
  end

  def build_error_response(message, code, status_code) do
    extensions = %{code: code, status_code: status_code}
    errors = [%{message: message, extensions: extensions}]

    Map.put(%{}, :errors, errors)
    |> Jason.encode!()
  end
end
