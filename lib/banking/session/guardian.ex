defmodule Banking.Session.Guardian do
  @moduledoc false

  use Guardian, otp_app: :banking

  alias Banking.Session

  def subject_for_token(session, _claims) do
    sub = to_string(session.id)
    {:ok, sub}
  end

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
