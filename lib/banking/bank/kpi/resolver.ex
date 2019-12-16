defmodule Banking.Bank.KPI.Resolver do
  @moduledoc false

  alias Banking.Bank.KPI

  def transactions_sum(_, _) do
    {:ok, KPI.transactions_sum()}
  end

  def transactions_sum_current_month(_, _) do
    {:ok, KPI.transactions_sum_current_month()}
  end

  def transactions_sum_previous_month(_, _) do
    {:ok, KPI.transactions_sum_previous_month()}
  end

  def transactions_sum_current_year(_, _) do
    {:ok, KPI.transactions_sum_current_year()}
  end

  def transactions_sum_previous_year(_, _) do
    {:ok, KPI.transactions_sum_previous_year()}
  end

  def transactions_sum_past_days(%{days: days}, _) do
    {:ok, KPI.transactions_sum_past_days(days)}
  end
end
