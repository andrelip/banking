defmodule Banking.Bank.Helper do
  @moduledoc false

  import Ecto.Query
  alias Banking.AccountManagement.Account
  alias Banking.Bank.Transaction
  alias Banking.Repo

  def write_transaction(source, target, amount) do
    %{source_id: source.id, target_id: target.id, amount: amount}
    |> Transaction.create_changeset()
  end

  def change_account_balance(account, amount) do
    account_id = account.id

    try do
      from(a in Account, where: a.id == ^account_id, update: [inc: [balance: ^amount]])
      |> Repo.update_all([])

      {:ok, account_id}
    rescue
      e in Postgrex.Error ->
        case e.postgres.constraint do
          "balance_should_be_positive" -> {:error, :balance_should_be_positive}
        end
    end
  end
end
