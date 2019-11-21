defmodule Banking.AccountManagement do
  alias Banking.Banking.AccountManagement.Account

  @type account_or_email_verification_code :: Account.t() | String.t()
  @type account :: Account.t()

  @callback create(RegistrationSchema.t()) :: {:ok, account} | {:error, Ecto.Changeset.t()}
  @callback get(Integer.t()) :: account | Exception.t()
  @callback get_by_public_id(String.t()) :: {:ok, account} | {:error, :account_not_found}
  @callback validade_email(account_or_email_verification_code) ::
              {:ok, account} | {:error, :account_not_found}
  @callback public_update(account) :: {:ok, account} | {:error, :account_not_found}
  @callback enable(account) :: :ok
  @callback disable(account) :: :ok
end
