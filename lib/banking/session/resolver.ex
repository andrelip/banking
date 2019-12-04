defmodule Banking.Session.Resolver do
  alias Banking.AccountManagement
  alias Banking.Session
  @moduledoc false

  import BankingWeb.ErrorHelpers, only: [translate_error: 1]

  def sign_in(data, _) do
    %{email: email, password: password} = data

    with {:find_user_by_email, user} when user != nil <-
           {:find_user_by_email, AccountManagement.get_user_by_email(email)},
         {:verify_password, true} <-
           {:verify_password, AccountManagement.verify_password(user, password)},
         {:ok, jwt, _claims} <- Session.create_jwt(user, "0.0.0.0") do
      {:ok, jwt}
    else
      {:find_user_by_email, nil} -> _sign_in_with_pending_email(email)
      {:verify_password, false} -> {:error, "wrong password"}
    end
  end

  defp _sign_in_with_pending_email(email) do
    case AccountManagement.get_user_by_pending_email(email) do
      nil -> {:error, "user not found with this email"}
      _user -> {:error, "you need to validate this email"}
    end
  end
end
