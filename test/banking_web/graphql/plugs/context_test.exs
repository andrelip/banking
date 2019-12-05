defmodule BankingWeb.GraphQL.Plugs.ContextTest do
  use BankingWeb.ConnCase

  alias Banking.AccountManagement.Fixtures
  alias Banking.AccountManagement.User
  alias Banking.Session
  alias BankingWeb.GraphQL.Plugs.Context
  alias BankingWeb.GraphQL.Plugs.Pipeline

  @opts Context.init([])

  test "should add remote_ip to absinthe context" do
    conn = build_conn() |> Context.call(@opts)

    assert get_in(conn.private, [:absinthe, :context, :remote_ip]) == "127.0.0.1"
  end

  test "should add current_user to absinthe context" do
    {:ok, %{user: user}} = Fixtures.create_user_with_account(%{}, validate_email: true)
    {:ok, jwt, _claims} = Session.create_jwt(user, "127.0.0.1")

    conn =
      build_conn()
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> Pipeline.call(%{})
      |> Context.call(@opts)

    assert %User{} = get_in(conn.private, [:absinthe, :context, :current_user])
  end

  test "should add auth_error to contextwhen bad token is provided" do
    conn =
      build_conn()
      |> put_req_header("authorization", "Bearer badtoken")
      |> Pipeline.call(%{})
      |> Context.call(@opts)

    assert get_in(conn.private, [:absinthe, :context, :auth_error]) ==
             "token is invalid or has expired"
  end
end
