defmodule Banking.AccountManagement.Emails.VerifyEmail do
  import Bamboo.Email
  alias Banking.AccountManagement.User

  def email_confirmation(%User{pending_email: nil}, _), do: {:error, :no_email_to_validate}

  def email_confirmation(%User{} = user, url) do
    email =
      [
        to: user.pending_email,
        from: Application.get_env(:banking, Banking.Mailer)[:support_email],
        subject: "Welcome to our banking app! Please verify your account.",
        html_body:
          "<strong>Thanks for joining!</strong><p>Please verify your email <a href=\"#{url}\"> clicking here</a>",
        text_body:
          "Thanks for joining! Please visit the following link to confirm your email: #{url}"
      ]
      |> new_email()

    {:ok, email}
  end
end
