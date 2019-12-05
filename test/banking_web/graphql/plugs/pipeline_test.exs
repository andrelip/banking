defmodule BankingWeb.GraphQL.Plugs.PipelineTest do
  use BankingWeb.ConnCase

  alias Banking.AccountManagement.Fixtures
  alias Banking.AccountManagement.User
  alias Banking.Session
  alias BankingWeb.GraphQL.Plugs.Pipeline

  test "should verify header and load resource" do
    {:ok, %{user: user}} = Fixtures.create_user_with_account(%{}, validate_email: true)
    {:ok, jwt, _claims} = Session.create_jwt(user, "127.0.0.1")

    conn =
      build_conn()
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> Pipeline.call(%{})

    assert get_in(conn.private, [:guardian_default_claims, "aud"]) == "banking"
    assert %User{} = get_in(conn.private, [:guardian_default_resource])
    assert get_in(conn.private, [:guardian_default_token]) == jwt
  end

  test "should handle errors" do
    conn =
      build_conn()
      |> put_req_header("authorization", "Bearer badtoken")
      |> Pipeline.call(%{})

    assert get_in(conn.private, [:auth_error]) == :token_is_invalid_or_expired
  end
end
