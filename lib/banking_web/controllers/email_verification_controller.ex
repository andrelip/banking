defmodule BankingWeb.EmailVerificationController do
  use BankingWeb, :controller
  alias Banking.AccountManagement
  alias Banking.AccountManagement.User
  alias Banking.Utils

  def update(conn, %{"code" => code}) do
    with {:get_user, %User{} = user} <-
           {:get_user, AccountManagement.get_user_by_pending_email_code(code)},
         {:validate_user, {:ok, _}} <- {:validate_user, AccountManagement.validate_email(user)} do
      # TODO placeholder to a proper flow
      conn |> text(gettext("Email has been validated!"))
    else
      {:get_user, nil} ->
        conn |> put_status(401) |> text(gettext("This code is invalid code or have expired"))

      {:validate_user, {:error, changeset}} ->
        errors = Utils.inline_errors(changeset)
        conn |> put_status(400) |> text(errors)
    end
  end
end
