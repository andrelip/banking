defmodule BankingWeb.EmailVerificationControllerTest do
  use BankingWeb.ConnCase
  alias Banking.AccountManagement.Account
  alias Banking.AccountManagement.Fixtures
  alias Banking.Bank.Seeds
  alias Banking.Repo

  describe "#update" do
    setup do
      Seeds.coldstart()
      {:ok, %{}}
    end

    test "GET when code is valid", %{conn: conn} do
      {:ok, %{user: user}} = Fixtures.create_user_with_account()
      conn = get(conn, "/verify_email/#{user.email_verification_code}")
      assert text_response(conn, 200) =~ "Email has been validated!"
    end

    test "GET should give bonus credit when code is valid", %{conn: conn} do
      {:ok, %{user: user, account: account}} = Fixtures.create_user_with_account()
      assert Decimal.eq?(account.balance, 0)

      get(conn, "/verify_email/#{user.email_verification_code}")
      account_updated = Repo.get(Account, account.id)
      assert Decimal.eq?(account_updated.balance, 1000)
    end

    test "GET when code is invalid", %{conn: conn} do
      conn = get(conn, "/verify_email/any_wrong_code")
      assert text_response(conn, 401) =~ "This code is invalid code or have expired"
    end

    test "GET when another account have this email validated", %{conn: conn} do
      conn = get(conn, "/verify_email/any_wrong_code")
      {:ok, %{user: user}} = Fixtures.create_user_with_account()
      {:ok, %{user: user2}} = Fixtures.create_user_with_account(%{document_id: "new123"})
      conn = get(conn, "/verify_email/#{user.email_verification_code}")
      assert text_response(conn, 200) =~ "Email has been validated!"
      conn = get(conn, "/verify_email/#{user2.email_verification_code}")
      assert text_response(conn, 400) =~ "Email has already been taken"
    end
  end
end
