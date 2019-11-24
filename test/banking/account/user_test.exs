defmodule Banking.Account.UserTest do
  use Banking.DataCase
  alias Banking.AccountManagement.Account
  alias Banking.AccountManagement.User

  @valid_user %{
    birthdate: ~D[2000-01-01],
    document_id: "123-456-789-91",
    document_type: "cpf",
    name: "User Example",
    pending_email: "user@example.com",
    password: "veRylonGAnd$Tr0ngPasSwrd"
  }

  @valid_user2 %{
    birthdate: ~D[2000-01-01],
    document_id: "999-999-999-99",
    document_type: "cpf",
    name: "User2 Example",
    pending_email: "user2@example.com",
    password: "veRylonGAnd$Tr0ngPasSwrd"
  }

  test "allowed_documents" do
    assert User.allowed_documents() == ["cpf", "rg", "passport", "cnpj"]
  end

  test "#create with valid attrs" do
    account = create_account()
    changeset = User.create_changeset(account, @valid_user)
    assert changeset.changes[:password_hash]
    assert changeset.changes[:pending_email]
    assert changeset.changes[:email_verification_code]
    assert changeset.valid?
  end

  # Testing only constraints since the main validation happens on Registration
  describe "#create with failing constraings" do
    setup do
      account = create_account()
      [account: account]
    end

    test "duplicated constraint", %{account: account} do
      changeset = User.create_changeset(account, @valid_user)
      {:ok, _} = Repo.insert(changeset)

      duplicated_docs = %{
        @valid_user2
        | document_id: @valid_user.document_id,
          document_type: @valid_user.document_type
      }

      duplicated_docs_chst = User.create_changeset(account, duplicated_docs)
      assert {:error, changeset} = Repo.insert(duplicated_docs_chst)
    end

    test "under 18 constration", %{account: account} do
      today = Timex.today()
      changeset = User.create_changeset(account, %{@valid_user | birthdate: today})
      assert {:error, changeset} = Repo.insert(changeset)
    end
  end

  defp create_account do
    Account.create_changeset() |> Repo.insert!()
  end
end
