defmodule Banking.Bank do
  @moduledoc """
  Processes all the financial operations and make an immutable register them as
  transactions.
  """
  alias Banking.Repo
  alias Banking.Bank.SpecialAccounts
  import Banking.Bank.Helper, only: [write_transaction: 3, change_account_balance: 2]

  def transfer(source, target, amount) do
    transaction_changeset = write_transaction(source, target, amount)
    reduce_from_source = fn _, _ -> change_account_balance(source, -amount) end
    increment_target = fn _, _ -> change_account_balance(target, amount) end

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:bank_transaction, transaction_changeset)
    |> Ecto.Multi.run(:reduce_from_source, reduce_from_source)
    |> Ecto.Multi.run(:increment_target, increment_target)
    |> Repo.transaction()
  end

  def withdrawal(source, amount) do
    cashout_register = SpecialAccounts.cashout()
    transfer(source, cashout_register, amount)
  end

  def add_bonus(target, amount) do
    bank_reserves = SpecialAccounts.bank_reserves()
    transfer(bank_reserves, target, amount)
  end
end
