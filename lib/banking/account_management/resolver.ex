defmodule Banking.AccountManagement.Resolver do
  @moduledoc false

  alias Banking.AccountManagement
  alias Banking.AccountManagement.Emails.EmailConfirmation
  alias Banking.AccountManagement.Registration
  alias Banking.Mailer
  alias BankingWeb.Router.Helpers, as: Routes

  import BankingWeb.ErrorHelpers, only: [translate_error: 1]

  def register(data, _) do
    registration_data = struct(%Registration{}, data)

    case AccountManagement.create(registration_data) do
      {:ok, %{user: user}} ->
        url =
          Routes.email_verification_url(
            BankingWeb.Endpoint,
            :update,
            user.email_verification_code
          )

        {:ok, email} = EmailConfirmation.email_confirmation(user, url)
        Mailer.deliver_later(email)

        {:ok, user}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:ok, %{errors: translate(changeset.errors)}}
    end
  end

  def me(_args, %{context: %{current_user: user}}) do
    {:ok, user}
  end

  def me(_args, %{context: %{auth_error: auth_error}}), do: {:error, auth_error}

  def me(_args, _), do: {:error, "you must be logged in"}

  defp translate(errors) do
    Enum.map(errors, fn {field, error} ->
      %{field: field, message: translate_error(error)}
    end)
  end
end
