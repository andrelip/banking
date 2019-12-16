defmodule Banking.BonusTest do
  use Banking.DataCase

  alias Banking.AccountManagement.Account
  alias Banking.AccountManagement.Fixtures
  alias Banking.Bank.Seeds
  alias Banking.Bank.SpecialAccounts
  alias Banking.Bonus

  setup do
    Seeds.coldstart()
    {:ok, %{}}
  end

  test "should credit account" do
    {:ok, %{account: account}} = Fixtures.create_user_with_account(%{}, validate_email: true)
    :ok = Bonus.maybe_do_first_access_bonus(account)
    account = Repo.get(Account, account.id)
    assert Decimal.eq?(account.balance, Decimal.new(1000))
  end

  test "should not give bonus twice" do
    {:ok, %{account: account}} = Fixtures.create_user_with_account(%{}, validate_email: true)
    :ok = Bonus.maybe_do_first_access_bonus(account)
    assert {:error, :account_not_eligible} == Bonus.maybe_do_first_access_bonus(account)
  end

  test "should not give bonus when reserve is empty" do
    {:ok, %{account: account}} = Fixtures.create_user_with_account()
    reserve = SpecialAccounts.bank_reserves()
    reserve |> change(%{balance: Decimal.new(0)}) |> Repo.update!()

    assert {:error, :source_has_no_funds} = Bonus.maybe_do_first_access_bonus(account)
  end
end
