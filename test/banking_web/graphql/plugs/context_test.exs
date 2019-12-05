defmodule BankingWeb.GraphQL.Plugs.ContextTest do
  use BankingWeb.ConnCase
  alias BankingWeb.GraphQL.Plugs.Context
  alias BankingWeb.GraphQL.Plugs.Pipeline
  alias Banking.AccountManagement.Fixtures
  alias Banking.AccountManagement.User
  alias Banking.Session

  test "should add remote_ip to absinthe context" do
    conn = build_conn() |> Context.call(%{})

    assert get_in(conn.private, [:absinthe, :context, :remote_ip]) == "127.0.0.1"
  end

  test "should add current_user to absinthe context" do
    {:ok, %{user: user}} = Fixtures.create_user_with_account(%{}, validate_email: true)
    {:ok, jwt, _claims} = Session.create_jwt(user, "127.0.0.1")

    conn =
      build_conn()
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> Pipeline.call(%{})
      |> Context.call(%{})

    assert %User{} = get_in(conn.private, [:absinthe, :context, :current_user])
  end
end
