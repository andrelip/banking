defmodule Banking.Account.UserTest do
  use Banking.DataCase
  alias Banking.AccountManagement.User

  @valid_user %{
    birthdate: ~D[2000-01-01],
    document_id: "123-456-789-91",
    document_type: "cpf",
    email: "user@example.com",
    name: "User Example",
    pending_email: "User Example",
    password: "veRylonGAnd$Tr0ngPasSwrd"
  }

  test "with valid attrs" do
    changeset = User.create_changeset(@valid_user, skip_validation: true)
    assert changeset.changes[:password_hash]
    assert changeset.changes[:pending_email]
    assert changeset.changes[:email_verification_code]
    assert changeset.valid?
  end
end
