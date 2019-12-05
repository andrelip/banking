defmodule BankingWeb.GraphQL.Plugs.PipelineTest do
  use BankingWeb.ConnCase
  alias BankingWeb.GraphQL.Plugs.Pipeline
  alias Banking.AccountManagement.User
  alias Banking.AccountManagement.Fixtures
  alias Banking.Session

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

    expected_msg =
      %{
        "errors" => [
          %{
            "extensions" => %{"code" => 401, "status_code" => "invalid_token"},
            "message" => "Session expired or invalid"
          }
        ]
      }
      |> Jason.encode!()

    assert conn.resp_body == expected_msg
  end
end
