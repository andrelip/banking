defmodule Banking.AccountManagement.EmailVerification do
  @moduledoc false

  alias Banking.AccountManagement.User
  alias Banking.Repo
  alias Ecto.Multi

  import Ecto.Changeset, only: [change: 2]

  def random_token(length \\ 64) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end

  @spec validate_email(User.t()) ::
          {:ok, User.t()} | {:error, :account_not_found}
  def validate_email(%User{pending_email: nil}),
    do: {:error, "no email to confirm"}

  def validate_email(user) do
    account = user |> Repo.preload(:account) |> Map.get(:account)

    Multi.new()
    |> Multi.update(
      :user,
      change(user, %{email: user.pending_email, pending_email: nil})
    )
    |> maybe_update_account(account)
    |> Repo.transaction()
  end

  defp maybe_update_account(multi, account) do
    case account.status do
      "pending" ->
        changeset = change(account, %{status: "active"})
        multi |> Multi.update(:account, changeset)

      _ ->
        multi
    end
  end
end
