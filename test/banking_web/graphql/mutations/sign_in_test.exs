defmodule BankingWeb.GraphQL.Mutations.SignInTest do
  use Banking.DataCase
  use Wormwood.GQLCase

  alias Banking.AccountManagement.Fixtures
  alias Banking.Session.Guardian

  load_gql(BankingWeb.GraphQL.Schema, "test/banking_web/graphql/gql/sign_in.gql")

  setup do
    user = Fixtures.valid_user_attrs()
    valid_variables = %{"email" => user.email, "password" => user.password}
    {:ok, %{valid_variables: valid_variables}}
  end

  test "syntax should be right" do
    result = query_gql()
    assert {:ok, data} = result
  end

  test "should sign in user with valid attrs", %{valid_variables: valid_variables} do
    Fixtures.create_user_with_account(%{}, validate_email: true)

    {:ok, data} = query_gql(variables: valid_variables, context: %{:remote_ip => "127.0.0.1"})

    jwt = get_in(data, [:data, "signIn"])
    {:ok, claims} = Guardian.decode_and_verify(jwt)
    assert claims["aud"] == "banking"
  end

  test "should reject user with pending email validation", %{valid_variables: valid_variables} do
    Fixtures.create_user_with_account(%{})

    {:ok, %{errors: errors}} =
      query_gql(variables: valid_variables, context: %{:remote_ip => "127.0.0.1"})

    error_msg = get_in(errors, [Access.at(0), :message])
    assert error_msg == "you need to validate this email"
  end

  test "should reject user with invalid_email", %{valid_variables: valid_variables} do
    {:ok, %{errors: errors}} =
      query_gql(variables: valid_variables, context: %{:remote_ip => "127.0.0.1"})

    error_msg = get_in(errors, [Access.at(0), :message])
    assert error_msg == "user not found with this email"
  end

  test "should reject user with bad password", %{valid_variables: valid_variables} do
    Fixtures.create_user_with_account(%{}, validate_email: true)

    invalid_variables = %{valid_variables | "password" => "bad password"}

    {:ok, %{errors: errors}} =
      query_gql(variables: invalid_variables, context: %{:remote_ip => "127.0.0.1"})

    error_msg = get_in(errors, [Access.at(0), :message])
    assert error_msg == "wrong password"
  end
end
