defmodule Banking.Bank.KPI.AmountVolumeTest do
  use Banking.DataCase

  alias Banking.Bank
  alias Banking.Bank.KPI.AmountVolume
  alias Banking.Bank.Seeds
  alias Decimal, as: D

  setup do
    Seeds.coldstart()
    :ok
  end

  describe "coldstart" do
    test "all methods should be 0" do
      assert AmountVolume.total() == D.new(0)
      assert AmountVolume.current_month() == D.new(0)
      assert AmountVolume.previous_month() == D.new(0)
      assert AmountVolume.current_year() == D.new(0)
      assert AmountVolume.previous_year() == D.new(0)
      assert AmountVolume.past_days(30) == D.new(0)
    end
  end

  describe "transactions" do
    setup do
      account = Seeds.create_account(4, 0)
      {:ok, %{bank_transaction: transaction}} = Bank.add_bonus(account, 1000)
      {:ok, %{account: account, transaction: transaction}}
    end

    test "#total" do
      assert D.eq?(AmountVolume.total(), 1000)
    end

    test "#current_month" do
      assert D.eq?(AmountVolume.current_month(), 1000)
      assert D.eq?(AmountVolume.previous_month(), 0)
    end

    test "#past_month", %{transaction: transaction} do
      date = Timex.now() |> Timex.shift(months: -1)

      transaction
      |> change(%{inserted_at: date})
      |> Repo.update!()

      assert D.eq?(AmountVolume.current_month(), 0)
      assert D.eq?(AmountVolume.previous_month(), 1000)
    end

    test "#current_year" do
      assert D.eq?(AmountVolume.current_year(), 1000)
      assert D.eq?(AmountVolume.previous_year(), 0)
    end

    test "#past_year", %{transaction: transaction} do
      date = Timex.now() |> Timex.shift(years: -1)

      transaction
      |> change(%{inserted_at: date})
      |> Repo.update!()

      assert D.eq?(AmountVolume.current_year(), 0)
      assert D.eq?(AmountVolume.previous_year(), 1000)
    end

    test "#past_days", %{transaction: transaction} do
      assert D.eq?(AmountVolume.past_days(1), 1000)
      date = Timex.now() |> Timex.shift(days: -15)

      transaction
      |> change(%{inserted_at: date})
      |> Repo.update!()

      assert D.eq?(AmountVolume.past_days(1), 0)
      assert D.eq?(AmountVolume.past_days(16), 1000)
    end
  end
end
