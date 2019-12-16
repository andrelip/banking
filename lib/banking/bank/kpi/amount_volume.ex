defmodule Banking.Bank.KPI.AmountVolume do
  @moduledoc """
  Reports the total amount volume that was transfered or wirthdrawed
  """
  import Ecto.Query

  alias Banking.Bank.Transaction
  alias Banking.Repo

  @doc """
  The sum of amount from all transactions in history
  """
  def total do
    sum_of_amount()
  end

  @doc """
  The sum of amount from all transactions created this month
  """
  def current_month do
    min_date = Timex.now() |> Timex.beginning_of_month()
    sum_of_amount(min_date: min_date)
  end

  @doc """
  The sum of amount from all transactions created past month
  """
  def previous_month do
    min_date = Timex.now() |> Timex.shift(months: -1) |> Timex.beginning_of_month()
    max_date = min_date |> Timex.end_of_month()
    sum_of_amount(min_date: min_date, max_date: max_date)
  end

  @doc """
  The sum of amount from all transactions created this year
  """
  def current_year do
    min_date = Timex.now() |> Timex.beginning_of_year()
    sum_of_amount(min_date: min_date)
  end

  @doc """
  The sum of amount from all transactions created past year
  """
  def previous_year do
    min_date = Timex.now() |> Timex.shift(years: -1) |> Timex.beginning_of_year()
    max_date = min_date |> Timex.end_of_year()
    sum_of_amount(min_date: min_date, max_date: max_date)
  end

  @doc """
  The sum of amount from all transactions created in the past n days
  """
  def past_days(days) do
    min_date = Timex.now() |> Timex.shift(days: -1 * days) |> Timex.beginning_of_day()
    sum_of_amount(min_date: min_date)
  end

  defp sum_of_amount(opts \\ []) do
    Transaction
    |> maybe_filter_min_date(opts[:min_date])
    |> maybe_filter_max_date(opts[:max_date])
    |> select([t], fragment("coalesce(?, 0)", sum(t.amount)))
    |> Repo.one()
  end

  defp maybe_filter_min_date(query, nil), do: query

  defp maybe_filter_min_date(query, min_date) do
    query |> where([t], t.inserted_at >= ^min_date)
  end

  defp maybe_filter_max_date(query, nil), do: query

  defp maybe_filter_max_date(query, max_date) do
    query |> where([t], t.inserted_at < ^max_date)
  end
end
