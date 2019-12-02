defmodule BankingWeb.GraphQL.CreateAccountTest do
  use Banking.DataCase
  use Wormwood.GQLCase
  load_gql(BankingWeb.GraphQL.Schema, "test/banking_web/graphql/create_account.gql")

  test "query should run fine" do
    result = query_gql()
    assert {:ok, query_data} = result
  end
end
