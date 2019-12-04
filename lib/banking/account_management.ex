defmodule Banking.AccountManagement do
  @moduledoc """
  Works as a public API to handle all the operations regarding user registration
  and account administration.
  """
  alias Banking.AccountManagement.Account
  alias Banking.AccountManagement.EmailVerification
  alias Banking.AccountManagement.Password
  alias Banking.AccountManagement.Registration
  alias Banking.AccountManagement.User
  alias Banking.Repo

  import Ecto.Changeset, only: [change: 2]

  @doc """
  Register a user with the following fields:

    * `name` - The FULL NAME of the user.
    * `email`
    * `password` - Must have length between 8 and 128 characters, contains a
    number, an upper-case, a lower-case and a symbol
    * `birthday`
    * `document_id` with `document_type` - The document if for the given type
     that could be of the following: `cpf`, `rg`, `passport` or `cnpj`.
  """
  @spec create(Registration.t()) ::
          {:ok, %{account: Account.t(), user: User.t()}}
          | {:error, Ecto.Changeset.t(Registration.t())}
  def create(registration) do
    registration |> Map.from_struct() |> Registration.insert()
  end

  @doc """
  Get an account by his id.
  """
  @spec get(integer()) :: Account.t() | nil
  def get(account_id), do: Repo.get(Account, account_id)

  @doc """
  Get the account by the public available UUID
  """
  @spec get_by_public_id(Ecto.UUID.t()) :: Account.t() | nil
  def get_by_public_id(uuid), do: Repo.get_by(Account, %{public_id: uuid})

  @doc """
  Get the account by the public available UUID
  """
  @spec get_by_public_id(Ecto.UUID.t()) :: Account.t() | nil
  def get_user_by_email(email), do: Repo.get_by(User, %{email: email})

  @doc """
  Get the account by the public available UUID
  """
  @spec get_by_public_id(Ecto.UUID.t()) :: Account.t() | nil
  def get_user_by_pending_email(email), do: Repo.get_by(User, %{pending_email: email})

  @doc """
  Block a given account
  """
  @spec disable(Account.t()) :: Account.t()
  def disable(account) do
    account |> change(status: "inactive") |> Repo.update!()
  end

  @doc """
  Enable a given account
  """
  @spec enable(Account.t()) :: Account.t()
  def enable(account) do
    account |> change(status: "active") |> Repo.update!()
  end

  @doc """
  Validate the email by moving `pending_email` to the main `email` field.

  If the user has a pending confirmation account associated then this account
  will be activated.
  """
  @spec validate_email(User.t()) ::
          {:ok, %{account: Account.t(), user: User.t()}} | {:error, <<_::152>>}
  def validate_email(user) do
    EmailVerification.validate_email(user)
  end

  @doc """
  Verifies the hashed password from the user against the raw password
  """
  @spec verify_password(User.t(), String.t()) :: true | false
  def verify_password(user, password) do
    Password.verify_password(password, user.password_hash)
  end
end
