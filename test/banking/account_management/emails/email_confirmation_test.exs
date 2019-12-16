defmodule Banking.AccountManagement.EmailConfirmationTest do
  use Banking.DataCase

  alias Banking.AccountManagement.Emails.EmailConfirmation
  alias Banking.AccountManagement.Fixtures
  alias Banking.AccountManagement.User

  test "should format email properly if user has pending_email" do
    {:ok, %{user: user}} = Fixtures.create_user_with_account()
    url = "https://www.test.com/my_key"
    {:ok, email} = EmailConfirmation.email_confirmation(user, url)

    assert %Bamboo.Email{} = email
    assert email.from == "support@test.com.br"

    assert email.html_body ==
             "<strong>Thanks for joining!</strong><p>Please verify your email <a href=\"#{url}\"> clicking here</a>"

    assert email.text_body ==
             "Thanks for joining! Please visit the following link to confirm your email: #{url}"

    assert email.subject == "Welcome to our banking app! Please verify your account."
    assert email.to == user.pending_email
  end

  test "should give and error if user does not have a pending email" do
    {:ok, %{user: user}} = Fixtures.create_user_with_account(%{}, validate_email: true)
    user = Repo.get(User, user.id)
    url = "https://www.test.com/my_key"
    assert {:error, :no_email_to_validate} == EmailConfirmation.email_confirmation(user, url)
  end
end
