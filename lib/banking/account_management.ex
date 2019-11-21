defmodule Banking.AccountManagement do
  @type account_or_email_verification_code :: Account.t() | String.t()

  @callback create(RegistrationSchema.t()) :: {:ok, Account.t()} | {:error, Ecto.Changeset.t()}
  @callback get(Integer.t()) :: Account.t() | Exception.t()
  @callback get_by_public_id(String.t()) :: {:ok, Account.t()} | {:error, :account_not_found}
  @callback validade_email(account_or_email_verification_code) :: {:ok, account} | {:error, :account_not_found}
  @callback public_update(account) :: {:ok, account} | {:error, :account_not_found}
end
