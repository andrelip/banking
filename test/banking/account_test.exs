defmodule Banking.AccountManagementTest do
  use Banking.DataCase
  alias Banking.AccountManagement
  alias Banking.AccountManagement.Registration
  alias Banking.AccountManagement.User
  alias Banking.AccountManagement.Account

  @valid_attrs %Registration{
    name: "User Test",
    email: "user@test.com",
    password: "veRylonGAnd$Tr0ngPasSwrd",
    birthdate: ~D[2000-01-01],
    document_id: "000.000.000-00",
    document_type: "cpf"
  }

  describe "#create" do
    test "valid_attrs" do
      assert {:ok, %{account: %Account{}, user: %User{}}} = AccountManagement.create(@valid_attrs)
    end

    test "bad email" do
      assert {:error, %Ecto.Changeset{}} =
               AccountManagement.create(%{@valid_attrs | email: "asd"})
    end

    test "weak password" do
      assert {:error, %Ecto.Changeset{}} =
               AccountManagement.create(%{@valid_attrs | password: "simplepassword"})

      assert {:error, %Ecto.Changeset{}} =
               AccountManagement.create(%{@valid_attrs | password: "Simplepassword"})

      assert {:error, %Ecto.Changeset{}} =
               AccountManagement.create(%{@valid_attrs | password: "s1mplepassword"})

      assert {:error, %Ecto.Changeset{}} =
               AccountManagement.create(%{@valid_attrs | password: "$implepassword"})

      assert {:error, %Ecto.Changeset{}} =
               AccountManagement.create(%{@valid_attrs | password: "$h0Rt"})
    end

    test "maturity" do
      assert {:error, %Ecto.Changeset{}} =
               AccountManagement.create(%{@valid_attrs | birthdate: Timex.today()})
    end

    test "duplicated document_id and document_type" do
      {:ok, _} = AccountManagement.create(@valid_attrs)
      assert {:error, _} = AccountManagement.create(%{@valid_attrs | email: "new@test.com"})
    end
  end

  test "#verify_password" do
    {:ok, %{account: _, user: user}} = AccountManagement.create(@valid_attrs)
    assert AccountManagement.verify_password(user, @valid_attrs.password)
  end

  test "#get" do
    {:ok, %{account: account, user: _}} = AccountManagement.create(@valid_attrs)
    assert %Account{} = AccountManagement.get(account.id)
    assert AccountManagement.get(0) == nil
  end

  test "#get_by_public_id" do
    {:ok, %{account: account, user: _}} = AccountManagement.create(@valid_attrs)
    assert %Account{} = AccountManagement.get_by_public_id(account.public_id)
    assert AccountManagement.get_by_public_id(Ecto.UUID.generate()) == nil
  end

  test "#disable" do
    {:ok, %{account: account, user: _}} = AccountManagement.create(@valid_attrs)
    account = AccountManagement.disable(account)
    assert account.status == "inactive"
  end

  test "#enable" do
    {:ok, %{account: account, user: _}} = AccountManagement.create(@valid_attrs)
    account = AccountManagement.enable(account)
    assert account.status == "active"
  end

  test "#enable and #disable" do
    {:ok, %{account: account, user: _}} = AccountManagement.create(@valid_attrs)
    account = AccountManagement.disable(account)
    assert account.status == "inactive"
    account = AccountManagement.enable(account)
    assert account.status == "active"
  end

  test "#validate_email" do
    {:ok, %{account: account, user: user}} = AccountManagement.create(@valid_attrs)
    assert account.status == "pending"
    assert user.email == nil
    assert user.pending_email == @valid_attrs.email
    {:ok, %{account: account, user: user}} = AccountManagement.validate_email(user)
    assert account.status == "active"
    assert user.email == @valid_attrs.email
    assert user.pending_email == nil
  end
end
