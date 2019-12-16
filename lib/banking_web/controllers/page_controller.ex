defmodule BankingWeb.PageController do
  use BankingWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: "/graphiql")
  end
end
