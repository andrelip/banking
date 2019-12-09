defmodule Banking.AccountManagement.EmailVerification do
  @moduledoc false

  alias Banking.AccountManagement.Account
  alias Banking.AccountManagement.User
  alias Banking.Repo
  alias Ecto.Multi

  import Ecto.Changeset

  def random_token(length \\ 64) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end

  @spec validate_email(User.t()) ::
          {:ok, %{account: Account.t(), user: User.t()}} | {:error, <<_::152>>}
  def validate_email(%User{pending_email: nil}),
    do: {:error, "no email to confirm"}

  def validate_email(user) do
    account = user |> Repo.preload(:account) |> Map.get(:account)

    Multi.new()
    |> Multi.update(
      :user,
      verify_email_changeset(user)
    )
    |> maybe_update_account(account)
    |> Repo.transaction()
    |> _validate_email
  end

  defp _validate_email({:ok, result}) do
    user = result.user
    account = result[:account] || user |> Repo.preload(:account) |> Map.get(:account)
    {:ok, %{account: account, user: user}}
  end

  defp _validate_email({:error, :user, changeset, _}) do
    {:error, changeset}
  end

  defp maybe_update_account(multi, account) do
    case account.status do
      "pending" ->
        changeset = account_status_to_active_changeset(account)
        multi |> Multi.update(:account, changeset)

      _ ->
        multi
    end
  end

  defp account_status_to_active_changeset(account) do
    account |> change(%{status: "active"})
  end

  defp verify_email_changeset(user) do
    user
    |> change(%{
      email: user.pending_email,
      pending_email: nil,
      email_verification_code: nil
    })
    |> unique_constraint(:email)
  end
end
