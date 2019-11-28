defmodule Banking.Bank.SpecialAccounts do
  @moduledoc """
  Keep track of the special accounts that are used as registers to share the
  same interface of common transactions.

  This solution might change in the future when in the case of supporting
  multiple banks or more complex operations.
  """

  alias Banking.AccountManagement.Account
  alias Banking.Repo

  @doc """
  Returns the account that represents the bank reserve.
  """
  def bank_reserves do
    Repo.get(Account, 1)
  end

  @doc """
  Returns the account that register all the money that was withdrawn in the bank.
  """
  def cashout do
    Repo.get(Account, 2)
  end

  @doc """
  Returns the account that register all the money paid as a bank fee. This is
  very useful as placeholder to be placed in the transaction table.
  """
  def fees do
    Repo.get(Account, 3)
  end
end
