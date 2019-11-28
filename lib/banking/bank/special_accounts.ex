defmodule Banking.Bank.SpecialAccounts do
  alias Banking.AccountManagement.Account
  alias Banking.Repo

  def bank_reserves do
    Repo.get(Account, 1)
  end

  def cashout do
    Repo.get(Account, 2)
  end
end
