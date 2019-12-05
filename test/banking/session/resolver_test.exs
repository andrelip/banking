defmodule Banking.Session.ResolverTest do
  use Banking.DataCase, async: false

  alias Banking.AccountManagement.Fixtures
  alias Banking.Session.Resolver

  @context %{context: %{remote_ip: "127.0.0.1"}}

  setup do
    user = Fixtures.valid_user_attrs()
    {:ok, %{user: user}}
  end

  describe "#sign_in" do
    test "should sign in validated users", %{user: user} do
      Fixtures.create_user_with_account(%{}, validate_email: true)

      assert {:ok, _jwt} =
               Resolver.sign_in(
                 %{email: user.email, password: user.password},
                 @context
               )
    end

    test "should given an error when email is pending validation", %{user: user} do
      Fixtures.create_user_with_account(%{})

      assert {:error, "you need to validate this email"} =
               Resolver.sign_in(%{email: user.email, password: user.password}, @context)
    end

    test "should not verify wrong password for not confirmed email", %{user: user} do
      Fixtures.create_user_with_account(%{})

      assert {:error, "you need to validate this email"} =
               Resolver.sign_in(%{email: user.email, password: "bad password"}, @context)
    end

    test "should verify password", %{user: user} do
      Fixtures.create_user_with_account(%{}, validate_email: true)

      assert {:error, "wrong password"} =
               Resolver.sign_in(%{email: user.email, password: "bad password"}, @context)
    end
  end
end
