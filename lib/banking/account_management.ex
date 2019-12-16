defmodule Banking.AccountManagement do
  @moduledoc """
  Provide functions to manage accounts and users
  """
  alias Banking.AccountManagement.Account
  alias Banking.AccountManagement.EmailVerification
  alias Banking.AccountManagement.Password
  alias Banking.AccountManagement.Registration
  alias Banking.AccountManagement.User
  alias Banking.Repo

  import Ecto.Changeset, only: [change: 2]
  import Ecto.Query

  @doc """
  Register a user with the following fields:

    * `name` - The FULL NAME of the user.
    * `email`
    * `password` - Must have length between 8 and 128 characters, contains a
    number, an upper-case, a lower-case and a symbol
    * `birthday`
    * `document_id` with `document_type` - The document if for the given type
     that could be of the following: ["cpf", "rg", "passport" or "cnpj"].

  ## Example:
      iex> attrs = %Registration{
      ...>     name: "User Test",
      ...>     email: "user@test.com",
      ...>     password: "veRylonGAnd$Tr0ngPasSwrd",
      ...>     birthdate: ~D[2000-01-01],
      ...>     document_id: "000.000.000-00",
      ...>     document_type: "cpf"
      ...>   }
      iex> AccountManagement.create(attrs)
      {:ok, %{account: %Banking.AccountManagement.Account{...}, user: %Banking.AccountManagement.User{...}}}

  """
  @spec create(Registration.t()) ::
          {:ok, %{account: Account.t(), user: User.t()}}
          | {:error, Ecto.Changeset.t(Registration.t())}
  def create(registration) do
    registration |> Map.from_struct() |> Registration.insert()
  end

  @doc """
  Get an account by his id.

  ## Example:
      iex> AccountManagement.get(1)
      %Banking.AccountManagement.Account{...}
  """
  @spec get(integer()) :: Account.t() | nil
  def get(account_id), do: Repo.get(Account, account_id)

  @doc """
  Get account by the public available UUID

  ## Example:
      iex> Banking.AccountManagement.get_user_by_email("6e91802b-0f5c-43ac-bbb8-adae12ec6b62")
      %Banking.AccountManagement.Account{...}
  """
  @spec get_by_public_id(Ecto.UUID.t()) :: Account.t() | nil
  def get_by_public_id(uuid), do: Repo.get_by(Account, %{public_id: uuid})

  @doc """
  Get user by the public available UUID

  ## Example:
      iex> Banking.AccountManagement.get_user_by_email("user@test.com")
      %Banking.AccountManagement.User{...}
  """
  @spec get_user_by_email(String.t()) :: User.t() | nil
  def get_user_by_email(email), do: Repo.get_by(User, %{email: email})

  @doc """
  Verifies if there is users with the given email as pending validation

  ## Example:
      iex> Banking.AccountManagement.users_with_pending_email("user@test.com")
      true
  """
  @spec users_with_pending_email?(String.t()) :: boolean
  def users_with_pending_email?(email) do
    count = from(u in User, where: u.pending_email == ^email, select: count(u.id)) |> Repo.one()

    case count do
      0 -> false
      _ -> true
    end
  end

  @doc """
  Get the account by the pending email verification code

  ## Example:

      iex> code = "3Ujd31gpI6DuB8IVB2k7ahJJFKqfl0ybSa5khMQ0cVKtQFsNRWSHKEzwftpsV9T4"
      iex> Banking.AccountManagement.get_user_by_pending_email_code(code)
      %Banking.AccountManagement.User{...}
  """
  @spec get_user_by_pending_email_code(String.t()) :: User.t() | nil
  def get_user_by_pending_email_code(email),
    do: Repo.get_by(User, %{email_verification_code: email})

  @doc """
  Block a given account

  ## Example:
      iex> Banking.AccountManagement.disable(account)
      %Banking.AccountManagement.Account{status: "inactive"}
  """
  @spec disable(Account.t()) :: Account.t()
  def disable(account) do
    account |> change(status: "inactive") |> Repo.update!()
  end

  @doc """
  Enable a given account

  ## Example:
      iex> Banking.AccountManagement.enable(account)
      %Banking.AccountManagement.Account{status: "active"}
  """
  @spec enable(Account.t()) :: Account.t()
  def enable(account) do
    account |> change(status: "active") |> Repo.update!()
  end

  @doc """
  Validate the email by moving `pending_email` to the main `email` field.

  If the user has a pending confirmation account associated then this account
  will be activated.

  ## Example:

      iex> Banking.AccountManagement.validate_email(user)
      {:ok, %{account: Banking.AccountManagement.Account{...}, user: Banking.AccountManagement.User{...}}}
  """
  @spec validate_email(User.t()) ::
          {:ok, %{account: Account.t(), user: User.t()}} | {:error, Ecto.Changeset.t()}
  def validate_email(user) do
    EmailVerification.validate_email(user)
  end

  @doc """
  Compares the raw password against the hashed one presented in user

  ## Examples:

      iex> Banking.AccountManagement.verify_password(user, "correct password")
      true

      iex> Banking.AccountManagement.verify_password(user, "bad password")
      false
  """
  @spec verify_password(User.t(), String.t()) :: true | false
  def verify_password(user, password) do
    Password.verify_password(password, user.password_hash)
  end

  @doc """
  Get the account from a given user

  ## Example:

      iex> Banking.AccountManagement.account_from_user(user)
      %Banking.AccountManagement.Account{...}
  """
  def account_from_user(user) do
    user |> Repo.preload([:account]) |> Map.get(:account)
  end
end
