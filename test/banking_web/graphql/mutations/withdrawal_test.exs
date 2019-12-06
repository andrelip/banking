defmodule BankingWeb.GraphQL.Mutations.WithdrawalTest do
  @moduledoc false

  use Banking.DataCase
  use Wormwood.GQLCase
  alias Banking.Bank.Seeds

  alias Banking.AccountManagement.Fixtures

  load_gql(BankingWeb.GraphQL.Schema, "test/banking_web/graphql/gql/withdrawal.gql")

  test "syntax should be right" do
    result = query_gql()
    assert {:ok, data} = result
  end

  test "should return true when the operation is valid" do
    Seeds.coldstart()

    {:ok, %{user: user}} =
      Fixtures.create_user_with_account(%{}, validate_email: true, add_balance: 1000)

    {:ok, %{data: data}} =
      query_gql(
        context: %{:remote_ip => "127.0.0.1", current_user: user},
        variables: %{"amount" => 1000}
      )

    assert data == %{"withdrawal" => true}
  end

  test "should give an error if user do not have balance enough balance" do
    Seeds.coldstart()

    {:ok, %{user: user}} =
      Fixtures.create_user_with_account(%{}, validate_email: true, add_balance: 99)

    {:ok, %{errors: errors}} =
      query_gql(
        context: %{:remote_ip => "127.0.0.1", current_user: user},
        variables: %{"amount" => 100}
      )

    assert get_in(errors, [Access.at(0), :message]) == "source account do not have enough funds"
  end

  test "should give an error if amount is 0 or less" do
    Seeds.coldstart()

    {:ok, %{user: user}} =
      Fixtures.create_user_with_account(%{}, validate_email: true, add_balance: 1000)

    {:ok, %{errors: errors}} =
      query_gql(
        context: %{:remote_ip => "127.0.0.1", current_user: user},
        variables: %{"amount" => 0}
      )

    assert get_in(errors, [Access.at(0), :message]) == "amount must be greater than 0"
  end

  test "should give an error if current_user is not signed in" do
    {:ok, %{errors: errors}} = query_gql(variables: %{"amount" => 1000})

    assert get_in(errors, [Access.at(0), :message]) == "you must be logged in"
  end
end
