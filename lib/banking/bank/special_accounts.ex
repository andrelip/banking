defmodule Banking.Bank.SpecialAccounts do
  @moduledoc """
  Keep track of the special accounts that are used as registers to share the
  same interface of common transactions. This solution might move to a proper
  table in the database if we starting to interact with different banks and
  sources.
  """

  alias Banking.AccountManagement.Account
  alias Banking.Repo

  @doc """
  Returns the account that represents the bank reserve.

  Example:
      iex> Banking.Bank.SpecialAccounts.bank_reserves
      %Banking.AccountManagement.Account{id: 1}
  """
  @spec bank_reserves() :: Account.t()
  def bank_reserves do
    Repo.get(Account, 1)
  end

  @doc """
  Returns the account that register all the money that was withdrawn in the bank.

  Example:
      iex> Banking.Bank.SpecialAccounts.cashout
      %Banking.AccountManagement.Account{id: 2}
  """
  @spec cashout() :: Account.t()
  def cashout do
    Repo.get(Account, 2)
  end

  @doc """
  Returns the account that register all the money paid as a bank fee. This is
  very useful as placeholder to be placed in the transaction table.

  Example:
      iex> Banking.Bank.SpecialAccounts.cashout
      %Banking.AccountManagement.Account{id: 3}
  """
  @spec fees() :: Account.t()
  def fees do
    Repo.get(Account, 3)
  end
end
