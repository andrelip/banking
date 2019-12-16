defmodule Banking.Bank.KPI do
  @moduledoc """
  Reports the total amount volume that was transfered or wirthdrawed
  """
  alias Banking.Bank.KPI.AmountVolume

  @doc """
  The sum of amount from all transactions in history
  """
  defdelegate transactions_sum(), to: AmountVolume, as: :total

  @doc """
  The sum of amount from all transactions created this month
  """
  defdelegate transactions_sum_current_month(), to: AmountVolume, as: :current_month

  @doc """
  The sum of amount from all transactions created past month
  """
  defdelegate transactions_sum_previous_month(), to: AmountVolume, as: :previous_month

  @doc """
  The sum of amount from all transactions created this year
  """
  defdelegate transactions_sum_current_year(), to: AmountVolume, as: :current_year

  @doc """
  The sum of amount from all transactions created past year
  """
  defdelegate transactions_sum_previous_year(), to: AmountVolume, as: :previous_year

  @doc """
  The sum of amount from all transactions created in the past n days
  """
  defdelegate transactions_sum_past_days(days), to: AmountVolume, as: :past_days
end
