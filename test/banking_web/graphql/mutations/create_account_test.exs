defmodule BankingWeb.GraphQL.Mutations.CreateAccountTest do
  use Banking.DataCase
  use Wormwood.GQLCase
  load_gql(BankingWeb.GraphQL.Schema, "test/banking_web/graphql/gql/create_account.gql")

  @valid_user %{
    birthdate: "2000-01-01",
    document_id: "123-456-789-91",
    document_type: "cpf",
    email: "user@example.com",
    name: "User Example",
    password: "veRylonGAnd$Tr0ngPasSwrd"
  }

  @valid_variables %{
    "name" => @valid_user.name,
    "birthdate" => @valid_user.birthdate,
    "documentId" => @valid_user.document_id,
    "documentType" => @valid_user.document_type,
    "email" => @valid_user.email,
    "password" => @valid_user.password
  }

  test "syntax should be right" do
    result = query_gql()
    assert {:ok, data} = result
  end

  test "should create user with valid attrs" do
    result = query_gql(variables: @valid_variables)

    {:ok, data} = result

    assert get_in(data, [:data, "createAccount", "__typename"]) == "User"
    assert get_in(data, [:data, "createAccount", "birthdate"]) == "2000-01-01"
    assert get_in(data, [:data, "createAccount", "email"]) == nil
    assert get_in(data, [:data, "createAccount", "name"]) == "User Example"
    assert get_in(data, [:data, "createAccount", "pendingEmail"]) == "user@example.com"
  end

  test "should display errors with invalid_attrs" do
    result = query_gql(variables: %{@valid_variables | "email" => "invalid"})

    {:ok, data} = result

    assert get_in(data, [:data, "createAccount", "__typename"]) == "ValidationErrors"

    assert get_in(data, [:data, "createAccount", "errors"]) == [
             %{"field" => "email", "message" => "has invalid format"}
           ]
  end
end
