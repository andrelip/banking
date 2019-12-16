defmodule Banking.Bonus do
  @moduledoc """
  Handles bonus and promotions
  """
  alias Banking.AccountManagement.Account
  alias Banking.Bank
  alias Banking.Bonus.Emails.FirstAccess, as: FirstAccessEmail
  alias Banking.Bonus.FirstAccess, as: FirstAccessBonus
  alias Banking.Mailer
  alias Banking.Repo

  @first_access_bonus_amount 1000

  @doc """
  Applies the `First Access Bonus` if the account is eligible.

  This gift is a 1,000.00 credit given to fresh Accounts as soon as the user
  verifies his email address.

  ## Example

      iex> Banking.Bonus.maybe_do_first_access_bonus(account)
      :ok

      iex> Banking.Bonus.maybe_do_first_access_bonus(not_eligible_account)
      {:error, :account_not_eligible}
  """
  @spec maybe_do_first_access_bonus(Account.t()) ::
          :ok | {:error, :account_not_eligible} | {:error, :source_has_no_funds}
  def maybe_do_first_access_bonus(account) do
    flag_account_changeset = FirstAccessBonus.create_changeset(account)
    add_bonus = fn _, _ -> Bank.add_bonus(account, @first_access_bonus_amount) end

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:flag_account, flag_account_changeset)
    |> Ecto.Multi.run(:add_bonus, add_bonus)
    |> Repo.transaction()
    |> _maybe_do_first_access_bonus(account)
  end

  defp _maybe_do_first_access_bonus({:ok, _}, account) do
    notify(:first_access, account)
    :ok
  end

  defp _maybe_do_first_access_bonus({:error, :flag_account, _, _}, _account) do
    {:error, :account_not_eligible}
  end

  defp _maybe_do_first_access_bonus({:error, :add_bonus, :source_has_no_funds, _}, _account) do
    {:error, :source_has_no_funds}
  end

  defp notify(:first_access, account) do
    user = account |> Repo.preload([:user]) |> Map.get(:user)

    user
    |> FirstAccessEmail.format(@first_access_bonus_amount)
    |> Mailer.deliver_now()
  end
end
