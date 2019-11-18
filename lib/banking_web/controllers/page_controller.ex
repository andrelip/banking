defmodule BankingWeb.PageController do
  use BankingWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
