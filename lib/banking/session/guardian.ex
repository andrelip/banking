defmodule Banking.Session.Guardian do
  @moduledoc """
  Defines how to serialize and deserialize sessions from JWT
  """

  use Guardian, otp_app: :banking

  alias Banking.Session

  @doc """
  Receives the sesion and use the session id to compose the JWT
  """
  def subject_for_token(session, _claims) do
    sub = to_string(session.id)
    {:ok, sub}
  end

  @doc """
  Receives the decoded JWT and tries to find the session

  ## Examples

      iex> Banking.Session.Guardian.resource_from_claims(claims)
      {:ok, %Banking.Session{...}}

      iex> Banking.Session.Guardian.resource_from_claims(claims)
      {:error, "session invalid or expired"}
  """
  def resource_from_claims(%{"sub" => id}) do
    session = Session.get(id)

    case session do
      nil ->
        {:error, "session invalid or expired"}

      session ->
        {:ok, session.user}
    end
  end
end
