defmodule Banking.AccountManagement.ResolverTest do
  use Banking.DataCase

  alias Banking.AccountManagement.Resolver
  alias Banking.AccountManagement.User

  @valid_user %{
    birthdate: ~D[2000-01-01],
    document_id: "123-456-789-91",
    document_type: "cpf",
    email: "user@example.com",
    name: "User Example",
    password: "veRylonGAnd$Tr0ngPasSwrd"
  }

  describe "#register" do
    test "should create with valid attrs" do
      assert {:ok, %User{}} = Resolver.register(@valid_user, nil)
    end

    test "should get an error with the fields for wrong attrs" do
      assert {:ok, %{errors: changeset_errors}} = Resolver.register(%{}, nil)

      assert changeset_errors == [
               %{field: :name, message: "can't be blank"},
               %{field: :email, message: "can't be blank"},
               %{field: :password, message: "can't be blank"},
               %{field: :birthdate, message: "can't be blank"},
               %{field: :document_id, message: "can't be blank"},
               %{field: :document_type, message: "can't be blank"}
             ]
    end
  end
end
