defmodule Banking.Account.RegistrationTest do
  use Banking.DataCase
  alias Banking.Accountmanagement.Registration

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
end
