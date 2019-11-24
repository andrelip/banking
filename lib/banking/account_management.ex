defmodule Banking.AccountManagement do
  alias Banking.AccountManagement.Account
  alias Banking.AccountManagement.Registration
  alias Banking.AccountManagement.User
  alias Banking.AccountManagement.EmailVerification
  alias Banking.Repo
  alias Ecto.Multi

  import Ecto.Changeset, only: [change: 2]

  @spec create(Registration.t()) ::
          {:ok, %{account: Account.t(), user: User.t()}}
          | {:error, Ecto.Changeset.t(Registration.t())}
  def create(registration) do
    registration |> Map.from_struct() |> Registration.insert()
  end

  @spec get(integer()) :: Account.t() | nil
  def get(account_id), do: Repo.get(Account, account_id)

  @spec get_by_public_id(Ecto.UUID.t()) :: Account.t() | nil
  def get_by_public_id(uuid), do: Repo.get_by(Account, %{public_id: uuid})

  @spec disable(Account.t()) :: Account.t()
  def disable(account) do
    account |> change(status: "desativated") |> Repo.update!()
  end

  @spec enable(Account.t()) :: Account.t()
  def enable(account) do
    account |> change(status: "active") |> Repo.update!()
  end

  def validate_email(user) do
    EmailVerification.validate_email(user)
  end
end
