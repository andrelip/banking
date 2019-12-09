defmodule Banking.Bank.Resolver do
  @moduledoc false

  import BankingWeb.Gettext

  alias Banking.AccountManagement
  alias Banking.Bank
  alias Banking.Utils

  def transfer(data, %{context: %{current_user: user}}) do
    user_account = AccountManagement.account_from_user(user)
    amount = data.amount

    case AccountManagement.get_by_public_id(data.target_account_public_id) do
      nil ->
        {:error, gettext("invalid account")}

      target_account ->
        _transfer(user_account, target_account, amount)
    end
  end

  def transfer(_args, %{context: %{auth_error: auth_error}}), do: {:error, auth_error}
  def transfer(_, _), do: {:error, "you must be logged in"}

  defp _transfer(user_account, target_account, amount) do
    Bank.transfer(user_account, target_account, amount) |> response()
  end

  def withdrawal(data, %{context: %{current_user: user}}) do
    user_account = AccountManagement.account_from_user(user)
    amount = data.amount

    Bank.withdrawal(user_account, amount) |> response()
  end

  def withdrawal(_args, %{context: %{auth_error: auth_error}}), do: {:error, auth_error}
  def withdrawal(_, _), do: {:error, "you must be logged in"}

  defp response(transaction) do
    case transaction do
      {:ok, _} ->
        {:ok, true}

      {:error, :reduce_from_source, :balance_should_be_positive, _} ->
        {:error, gettext("source account do not have enough funds")}

      {:error, :bank_transaction, changeset, _} ->
        error_msg =
          Utils.translate_errors(changeset)
          |> Enum.map(fn {k, v} -> "#{k} #{List.first(v)}" end)
          |> Enum.join("/n")

        {:error, error_msg}
    end
  end
end
