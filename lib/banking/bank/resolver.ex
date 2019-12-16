defmodule Banking.Bank.Resolver do
  @moduledoc false

  import BankingWeb.Gettext

  alias Banking.AccountManagement
  alias Banking.Bank

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

  def withdraw(data, %{context: %{current_user: user}}) do
    user_account = AccountManagement.account_from_user(user)
    amount = data.amount

    Bank.withdraw(user_account, amount) |> response()
  end

  def withdraw(_args, %{context: %{auth_error: auth_error}}), do: {:error, auth_error}
  def withdraw(_, _), do: {:error, "you must be logged in"}

  defp response(transaction) do
    case transaction do
      {:ok, _} ->
        {:ok, true}

      {:error, :source_has_no_funds} ->
        {:error, gettext("source account do not have enough funds")}

      {:error, :amount_is_zero} ->
        {:error, "amount must be greater than 0"}
    end
  end
end
