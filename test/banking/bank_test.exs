defmodule Banking.BankTest do
  use Banking.DataCase

  alias Banking.AccountManagement.Account
  alias Banking.Bank
  alias Banking.Bank.Seeds
  alias Banking.Bank.SpecialAccounts
  alias Decimal, as: D

  setup do
    Seeds.coldstart()
    :ok
  end

  test "special accounts" do
    assert SpecialAccounts.bank_reserves()
    assert SpecialAccounts.cashout()
    assert SpecialAccounts.fees()
  end

  describe "#add_bonus" do
    test "should transfer money from reserve to a given account" do
      bank = SpecialAccounts.bank_reserves()
      account = Seeds.create_account(4, 0)

      {:ok, _data} = Bank.add_bonus(account, 1000)

      account_after = Repo.get(Account, account.id)
      bank_after = SpecialAccounts.bank_reserves()

      assert D.eq?(account_after.balance, 1000)
      assert D.eq?(bank_after.balance, D.sub(bank.balance, 1000))
    end

    test "should be greater than 0" do
      account = Seeds.create_account(4, 0)
      assert {:error, :amount_is_zero} = Bank.add_bonus(account, 0)
    end
  end

  describe "#withdraw" do
    test "should reduce money from account and adds to cashout register" do
      _cashout_register = SpecialAccounts.cashout()
      account = Seeds.create_account(4, 1000)

      {:ok, _data} = Bank.withdraw(account, 100)

      account_after = Repo.get(Account, account.id)
      cashout_register_after = SpecialAccounts.cashout()

      assert D.eq?(account_after.balance, 900)
      assert D.eq?(cashout_register_after.balance, 100)
    end

    test "amount should be greater than 0" do
      SpecialAccounts.cashout()
      account = Seeds.create_account(4, 1000)

      assert {:error, :amount_is_zero} = Bank.withdraw(account, 0)
    end

    test "balance should never be negative" do
      account = Seeds.create_account(4, 1000)

      assert {:error, :source_has_no_funds} = Bank.withdraw(account, 1001)
    end
  end

  describe "#transfer" do
    test "should transfer money from one account to the other" do
      account1 = Seeds.create_account(4, 1000)
      account2 = Seeds.create_account(5, 1000)

      {:ok, _data} = Bank.transfer(account1, account2, 1000)

      account1_after = Repo.get(Account, account1.id)
      account2_after = Repo.get(Account, account2.id)

      assert D.eq?(account1_after.balance, Decimal.new(0))
      assert D.eq?(account2_after.balance, 2000)
    end

    test "balance should never be negative" do
      account1 = Seeds.create_account(4, 1000)
      account2 = Seeds.create_account(5, 1000)

      assert {:error, :source_has_no_funds} = Bank.transfer(account1, account2, 1001)
    end

    test "amount should be greater than 0" do
      account1 = Seeds.create_account(4, 1000)
      account2 = Seeds.create_account(5, 1000)

      {:error, :amount_is_zero} = Bank.transfer(account1, account2, 0)
    end
  end
end
