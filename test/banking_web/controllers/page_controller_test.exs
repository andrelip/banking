defmodule BankingWeb.PageControllerTest do
  use BankingWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert redirected_to(conn, 302) =~ "/graphiql"
  end
end
