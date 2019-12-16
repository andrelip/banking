defmodule Banking.Bank.KPI do
  @moduledoc """
  Provides many different indicators about the bank operations
  """

  alias Banking.Bank.KPI.AmountVolume

  @doc """
  Calculates the sum of amount from all transactions in history

  Example:

      iex> Banking.Bank.KPI.transactions_sum()
      #Decimal<1000.0000>
  """
  defdelegate transactions_sum(), to: AmountVolume, as: :total

  @doc """
  Calculates the sum of amount from all transactions created this month

    Example:

      iex> Banking.Bank.KPI.transactions_sum_current_month()
      #Decimal<1000.0000>
  """
  defdelegate transactions_sum_current_month(), to: AmountVolume, as: :current_month

  @doc """
  Calculates the sum of amount from all transactions created past month

    Example:

      iex> Banking.Bank.KPI.transactions_sum_previous_month()
      #Decimal<1000.0000>
  """
  defdelegate transactions_sum_previous_month(), to: AmountVolume, as: :previous_month

  @doc """
  Calculates the sum of amount from all transactions created this year

    Example:

      iex> Banking.Bank.KPI.transactions_sum_current_year()
      #Decimal<1000.0000>
  """
  defdelegate transactions_sum_current_year(), to: AmountVolume, as: :current_year

  @doc """
  Calculates the sum of amount from all transactions created past year

    Example:

      iex> Banking.Bank.KPI.transactions_sum_previous_year()
      #Decimal<1000.0000>
  """
  defdelegate transactions_sum_previous_year(), to: AmountVolume, as: :previous_year

  @doc """
  Calculates the sum of amount from all transactions created in the past n days

    Example:

      iex> Banking.Bank.KPI.transactions_sum_past_days()
      #Decimal<1000.0000>
  """
  defdelegate transactions_sum_past_days(days), to: AmountVolume, as: :past_days
end
