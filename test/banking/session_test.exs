defmodule Banking.SessionTest do
  use Banking.DataCase
  alias Banking.AccountManagement
  alias Banking.AccountManagement.Registration

  @valid_user %{
    birthdate: ~D[2000-01-01],
    document_id: "123-456-789-91",
    document_type: "cpf",
    email: "user@example.com",
    name: "User Example",
    password: "veRylonGAnd$Tr0ngPasSwrd"
  }

  test "#create" do
    user = create_user()
    {:ok, session} = Banking.Session.create(user, "0.0.0.0")
    session = session |> Repo.preload([:user])

    assert session.user_id == user.id
    assert session.ip_address == "0.0.0.0"

    {:ok, session2} =
      Banking.Session.create(user, "0.0.0.0", %{
        device_id: "id123",
        device_type: "IOS"
      })

    assert session2.device_id == "id123"
    assert session2.device_type == "IOS"
  end

  test "#get" do
    user = create_user()
    {:ok, session} = Banking.Session.create(user, "0.0.0.0")
    assert session.id == Banking.Session.get(session.id) |> Map.get(:id)
  end

  test "#to_jwt" do
    user = create_user()
    {:ok, session} = Banking.Session.create(user, "0.0.0.0")
    {:ok, jwt, claims} = Banking.Session.to_jwt(session)
    assert String.length(jwt) > 20
    assert claims["sub"] == "#{session.id}"
  end

  test "#create_jwt" do
    user = create_user()
    {:ok, jwt, _claims} = Banking.Session.create_jwt(user, "0.0.0.0")
    assert String.length(jwt) > 20
  end

  defp create_user do
    {:ok, %{user: user}} = AccountManagement.create(struct(Registration, @valid_user))
    user
  end
end
