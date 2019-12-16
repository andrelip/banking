defmodule Banking.Bank.Emails.Transference do
  @moduledoc false

  import Bamboo.Email

  alias Banking.Repo

  def build_email(bank_transaction) do
    user = bank_transaction |> Repo.preload(source: :user) |> Map.get(:source) |> Map.get(:user)
    target = bank_transaction |> Repo.preload([:target]) |> Map.get(:target)
    subject = "Your transfer receipt to account #{target.public_id}"

    [
      to: user.email,
      from: Application.get_env(:banking, Banking.Mailer)[:support_email],
      subject: subject,
      html_body:
        "You have transfered R$ #{format_decimal(bank_transaction.amount)} to #{target.public_id}",
      text_body:
        "You have transfered R$ #{format_decimal(bank_transaction.amount)} to #{target.public_id}"
    ]
    |> new_email()
  end

  defp format_decimal(value) do
    value |> Decimal.round(2) |> Decimal.to_string()
  end
end
