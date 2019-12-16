defmodule Banking.Bank do
  @moduledoc """
  Processes all the financial operations
  """
  alias Banking.AccountManagement.Account
  alias Banking.Bank.Emails.Transference
  alias Banking.Bank.SpecialAccounts
  alias Banking.Bank.Transaction
  alias Banking.Repo

  import Banking.Bank.Helper, only: [write_transaction: 3, change_account_balance: 2]

  @type transaction_result ::
          {:ok, %{bank_transaction: Transaction.t()}}
          | {:error, :source_has_no_funds}
          | {:error, :amount_is_zero}

  @doc """
  Transfer money from the source account to the target one.

  Example:

      iex> Bank.transfer(source_account, target_account, 100)
      {:ok,
        %{
          bank_transaction: %Banking.Bank.Transaction{
            __meta__: #Ecto.Schema.Metadata<:loaded, "bank_transactions">,
            amount: #Decimal<100>,
            id: 1,
            inserted_at: ~N[2019-11-28 04:36:24],
            public_id: "54469e74-79da-468c-aafc-6a0bbfb4af8e",
            source_id: 4,
            target_id: 5,
            updated_at: ~N[2019-11-28 04:36:24]
          }}
  """
  # @spec transfer(Account.t(), Account.t(), Decimal.t()) ::
  #         {:ok, map()} | {:error, :source_has_no_funds} | {:error, :amount_is_zero}
  @spec transfer(Account.t(), Account.t(), Decimal.t()) :: transaction_result()
  def transfer(source, target, amount) do
    transaction_changeset = write_transaction(source, target, amount)
    reduce_from_source = fn _, _ -> change_account_balance(source, Decimal.mult(-1, amount)) end
    increment_target = fn _, _ -> change_account_balance(target, amount) end

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:bank_transaction, transaction_changeset)
    |> Ecto.Multi.run(:reduce_from_source, reduce_from_source)
    |> Ecto.Multi.run(:increment_target, increment_target)
    |> Repo.transaction()
    |> _transfer
  end

  defp _transfer({:ok, data}), do: {:ok, data}

  defp _transfer({:error, :reduce_from_source, :balance_should_be_positive, _}),
    do: {:error, :source_has_no_funds}

  defp _transfer({:error, :bank_transaction, _, _}) do
    # hardcoded because it's the only point of failure in the changeset.
    # might need update if validation changes
    {:error, :amount_is_zero}
  end

  @doc """
  Withdraw money from a given account

  Example:

      iex> Bank.withdraw(account, 10)
      {:ok,
        %{
          bank_transaction: %Banking.Bank.Transaction{
          __meta__: #Ecto.Schema.Metadata<:loaded, "bank_transactions">,
          amount: #Decimal<10>,
          id: 2,
          inserted_at: ~N[2019-11-28 04:37:54],
          public_id: "c5f3e493-11c4-4703-82c7-c001f7294619",
          source_id: 4,
          target_id: 2,
          updated_at: ~N[2019-11-28 04:37:54]
        }}
  """
  @spec withdraw(Account.t(), Decimal.t()) :: transaction_result()
  def withdraw(source, amount) do
    cashout_register = SpecialAccounts.cashout()
    transfer(source, cashout_register, amount)
  end

  @doc """
  Add funds to a given account

  Example:

      iex> Bank.withdraw(account, 10)
      {:ok,
        %{
          bank_transaction: %Banking.Bank.Transaction{
          __meta__: #Ecto.Schema.Metadata<:loaded, "bank_transactions">,
          amount: #Decimal<1000>,
          id: 3,
          inserted_at: ~N[2019-11-28 04:40:42],
          public_id: "9086a2b5-7f21-494b-9d83-28c2a10d0432",
          source_id: 1,
          target_id: 4,
          updated_at: ~N[2019-11-28 04:40:42]
        }}
  """
  @spec add_bonus(Account.t(), Decimal.t()) :: transaction_result()
  def add_bonus(target, amount) do
    bank_reserves = SpecialAccounts.bank_reserves()
    transfer(bank_reserves, target, amount)
  end
end
