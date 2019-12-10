defmodule Banking.Bonus.Emails.FirstAccess do
  @moduledoc """
  Builder for first access bonus notification
  """

  import Bamboo.Email
  import BankingWeb.Gettext

  def format(user, _amount) do
    subject = gettext("You received a bonus!")
    from = Application.get_env(:banking, Banking.Mailer)[:support_email]

    [
      to: user.email,
      from: from,
      subject: subject,
      # TODO dynamic ammount based on currency format
      html_body:
        "<strong>#{gettext("Thanks for joining!")}</strong><p>#{
          gettext("We just credit your account with")
        } R$ 1.000,00. Enjoy!</a>",
      text_body:
        "#{gettext("Thanks for joining!")} #{gettext("We just credit your account with")} R$ 1.000,00. Enjoy!"
    ]
    |> new_email()
  end
end
