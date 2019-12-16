defmodule BankingWeb.GraphQL.MeTest do
  use Banking.DataCase
  use Wormwood.GQLCase

  alias Banking.AccountManagement.Fixtures

  load_gql(BankingWeb.GraphQL.Schema, "test/banking_web/graphql/gql/me.gql")

  test "syntax should be right" do
    result = query_gql()
    assert {:ok, data} = result
  end

  test "should sign in user with valid attrs" do
    {:ok, %{user: user}} = Fixtures.create_user_with_account(%{}, validate_email: true)

    {:ok, %{data: data}} = query_gql(context: %{:remote_ip => "127.0.0.1", current_user: user})

    assert get_in(data, ["me", "birthdate"]) == "2000-01-01"
    assert get_in(data, ["me", "email"]) == nil
    assert get_in(data, ["me", "name"]) == "User Test"
    assert get_in(data, ["me", "pendingEmail"]) == "user@test.com"
    assert get_in(data, ["me", "account", "publicId"]) |> String.length() > 10
  end

  test "should not return user when not authenticated" do
    {:ok, %{data: data, errors: errors}} = query_gql(context: %{:remote_ip => "127.0.0.1"})

    assert data == %{"me" => nil}
    assert get_in(errors, [Access.at(0), :message]) == "you must be logged in"
  end

  test "should not return user when token has expired" do
    {:ok, %{data: data, errors: errors}} =
      query_gql(
        context: %{:remote_ip => "127.0.0.1", auth_error: "token is invalid or has expired"}
      )

    assert data == %{"me" => nil}
    assert get_in(errors, [Access.at(0), :message]) == "token is invalid or has expired"
  end
end
