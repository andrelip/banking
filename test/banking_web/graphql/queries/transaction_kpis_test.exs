defmodule BankingWeb.GraphQL.TransactionKPIsTest do
  use Banking.DataCase
  use Wormwood.GQLCase

  alias Banking.Bank
  alias Banking.Bank.Seeds

  @key "uj/mQfYOZ0mo4P0WQUqmxmO1ROM04b33rykJ+kovboeyeyppIP3+wDxxeTViXJZ4"

  load_gql(BankingWeb.GraphQL.Schema, "test/banking_web/graphql/gql/transaction_kpis.gql")

  test "syntax should be right" do
    result = query_gql()
    assert {:ok, data} = result
  end

  test "should give an error with missing key" do
    {:ok, %{errors: errors}} = query_gql()

    assert get_in(errors, [Access.at(0), :message]) ==
             "In argument \"key\": Expected type \"String!\", found null."
  end

  test "should give an error with wrong key" do
    {:ok, %{data: data, errors: errors}} = query_gql(variables: %{"key" => "badkey"})
    assert data == %{"transactionsKpi" => nil}
    assert get_in(errors, [Access.at(0), :message]) == "wrong key"
  end

  describe "when valid" do
    setup do
      Seeds.coldstart()

      account = Seeds.create_account(4, 0)
      {:ok, _} = Bank.add_bonus(account, 1000)
      {:ok, %{bank_transaction: transaction}} = Bank.add_bonus(account, 5000)
      {:ok, %{account: account, transaction: transaction}}
    end

    test "should present valid values", %{transaction: transaction} do
      date = Timex.now() |> Timex.shift(years: -1)

      transaction
      |> change(%{inserted_at: date})
      |> Repo.update!()

      {:ok, %{data: data}} =
        query_gql(
          variables: %{
            "key" => @key
          }
        )

      assert get_in(data, ["transactionsKpi", "sumTotal"]) == "6000.0000"
      assert get_in(data, ["transactionsKpi", "pastDays1000"]) == "6000.0000"

      assert get_in(data, ["transactionsKpi", "sumCurrentMonth"]) == "1000.0000"
      assert get_in(data, ["transactionsKpi", "sumCurrentYear"]) == "1000.0000"
      assert get_in(data, ["transactionsKpi", "pastDays1"]) == "1000.0000"

      assert get_in(data, ["transactionsKpi", "sumPreviousMonth"]) == "0"

      assert get_in(data, ["transactionsKpi", "sumPreviousYear"]) == "5000.0000"
    end
  end
end
