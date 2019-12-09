defmodule Banking.AccountManagement.Fixtures do
  @moduledoc false

  alias Banking.AccountManagement
  alias Banking.AccountManagement.Registration
  alias Banking.Bank

  @valid_attrs %Registration{
    name: "User Test",
    email: "user@test.com",
    password: "veRylonGAnd$Tr0ngPasSwrd",
    birthdate: ~D[2000-01-01],
    document_id: "000.000.000-00",
    document_type: "cpf"
  }

  def create_user_with_account do
    create_user_with_account(%{}, [])
  end

  def create_user_with_account(merge_attrs, opts \\ []) do
    attrs = Map.merge(@valid_attrs, merge_attrs)
    {:ok, data} = AccountManagement.create(attrs)
    %{user: user, account: account} = data

    case opts[:validate_email] do
      true ->
        AccountManagement.validate_email(user)

      _ ->
        nil
    end

    case opts[:add_balance] do
      nil ->
        nil

      add_balance ->
        account |> Bank.add_bonus(add_balance)
    end

    {:ok, %{user: user, account: account}}
  end

  def valid_user_attrs do
    @valid_attrs
  end
end
