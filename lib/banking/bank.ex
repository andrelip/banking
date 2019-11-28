defmodule Banking.Bank do
  import Ecto.Query
  alias Banking.Repo
  alias Banking.AccountManagement.Account
  alias Banking.Bank.Transaction

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
    transaction_changeset = write_transaction(source, source, amount)
    subtract_from_source = fn _, _ -> change_account_balance(source, -amount) end

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:bank_transaction, transaction_changeset)
    |> Ecto.Multi.run(:subtract_from_source, subtract_from_source)
    |> Repo.transaction()
  end

  defp write_transaction(source, target, amount) do
    %{source_id: source.id, target_id: target.id, amount: amount}
    |> Transaction.create_changeset()
  end

  defp change_account_balance(account, amount) do
    account_id = account.id

    try do
      from(a in Account, where: a.id == ^account_id, update: [inc: [balance: ^amount]])
      |> Repo.update_all([])

      {:ok, account_id}
    rescue
      e in Postgrex.Error ->
        case e.postgres.constraint do
          "balance_should_be_positive" -> {:error, :balance_should_be_positive}
          _ -> e
        end

      e ->
        {:error, e}
    end
  end
end
