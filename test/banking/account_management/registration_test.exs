defmodule Banking.AccountManagement.RegistrationTest do
  use Banking.DataCase
  alias Banking.AccountManagement.Registration
  alias Banking.AccountManagement.User

  # TODO refactor this overused struct
  @valid_user %{
    birthdate: ~D[2000-01-01],
    document_id: "123-456-789-91",
    document_type: "cpf",
    email: "user@example.com",
    name: "User Example",
    password: "veRylonGAnd$Tr0ngPasSwrd"
  }

  test "with valid attrs" do
    changeset = Registration.changeset(%Registration{}, @valid_user)
    assert changeset.valid?
  end

  test "insert" do
    {:ok, %{account: _account, user: user}} = Registration.insert(@valid_user)
    user = User |> Repo.get(user.id) |> Repo.preload(:account)
    account = user.account

    assert account.public_id
    assert account.status == "pending"

    assert user.password_hash
    assert user.name == @valid_user.name
    assert user.document_type == @valid_user.document_type
    assert user.document_id == @valid_user.document_id
    assert user.pending_email == @valid_user.email

    refute user.password
    refute user.email
  end
end
