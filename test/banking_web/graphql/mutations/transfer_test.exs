defmodule BankingWeb.GraphQL.Mutations.TransferTest do
  use Banking.DataCase
  use Wormwood.GQLCase

  alias Banking.AccountManagement.Fixtures
  alias Banking.Bank.Seeds

  load_gql(BankingWeb.GraphQL.Schema, "test/banking_web/graphql/gql/transfer.gql")

  test "syntax should be right" do
    result = query_gql()
    assert {:ok, data} = result
  end

  test "should return true when the operation is valid" do
    Seeds.coldstart()

    {:ok, %{user: user}} =
      Fixtures.create_user_with_account(%{}, validate_email: true, add_balance: 1000)

    {:ok, %{account: account2}} =
      Fixtures.create_user_with_account(%{document_id: "uniquedoc2", email: "user2@test.com"},
        validate_email: true,
        add_balance: 1000
      )

    {:ok, %{data: data}} =
      query_gql(
        context: %{:remote_ip => "127.0.0.1", current_user: user},
        variables: %{"amount" => 1000, "targetAccountPublicId" => account2.public_id}
      )

    assert data == %{"transfer" => true}
  end

  test "should give an error if invalid target account public id" do
    Seeds.coldstart()

    {:ok, %{user: user}} =
      Fixtures.create_user_with_account(%{}, validate_email: true, add_balance: 1000)

    {:ok, %{errors: errors}} =
      query_gql(
        context: %{:remote_ip => "127.0.0.1", current_user: user},
        variables: %{"amount" => 1000, "targetAccountPublicId" => Ecto.UUID.generate()}
      )

    assert get_in(errors, [Access.at(0), :message]) == "invalid account"
  end

  test "should give an error if source account do not have balance enough balance" do
    Seeds.coldstart()

    {:ok, %{user: user}} =
      Fixtures.create_user_with_account(%{}, validate_email: true, add_balance: 999)

    {:ok, %{account: account2}} =
      Fixtures.create_user_with_account(%{document_id: "uniquedoc2", email: "user2@test.com"},
        validate_email: true,
        add_balance: 1000
      )

    {:ok, %{errors: errors}} =
      query_gql(
        context: %{:remote_ip => "127.0.0.1", current_user: user},
        variables: %{"amount" => 1000, "targetAccountPublicId" => account2.public_id}
      )

    assert get_in(errors, [Access.at(0), :message]) == "source account do not have enough funds"
  end

  test "should give an error if current_user is not signed in" do
    {:ok, %{errors: errors}} =
      query_gql(variables: %{"amount" => 1000, "targetAccountPublicId" => "any valid uuid"})

    assert get_in(errors, [Access.at(0), :message]) == "you must be logged in"
  end
end
