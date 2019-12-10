defmodule Banking.AccountManagement.Emails.VerifyEmail do
  @moduledoc """
  Builder for email confirmation
  """

  import Bamboo.Email
  import BankingWeb.Gettext

  alias Banking.AccountManagement.User

  def email_confirmation(%User{pending_email: nil}, _), do: {:error, :no_email_to_validate}

  def email_confirmation(%User{} = user, url) do
    subject = gettext("Welcome to our banking app! Please verify your account.")
    please_verify_your_email = gettext("Please verify your email")
    please_verify_your_email_txt = "Please visit the following link to confirm your email:"
    thanks_for_joining = gettext("Thanks for joining!")
    clicking_here = gettext("clicking here")

    email =
      [
        to: user.pending_email,
        from: Application.get_env(:banking, Banking.Mailer)[:support_email],
        subject: subject,
        html_body:
          "<strong>#{thanks_for_joining}</strong><p>#{please_verify_your_email} <a href=\"#{url}\"> #{
            clicking_here
          }</a>",
        text_body: "#{thanks_for_joining} #{please_verify_your_email_txt} #{url}"
      ]
      |> new_email()

    {:ok, email}
  end
end
