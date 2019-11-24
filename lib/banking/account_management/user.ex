defmodule Banking.AccountManagement.User do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  import BankingWeb.Gettext
  alias Banking.AccountManagement.Account
  alias Banking.AccountManagement.Password
  alias Banking.AccountManagement.EmailVerification

  @valid_attrs [
    :name,
    :birthdate,
    :password,
    :pending_email,
    :document_type,
    :document_id
  ]

  schema "users" do
    field :birthdate, :date
    field :document_id, :string
    field :document_type, :string
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :pending_email, :string
    field :email_verification_code, :string
    belongs_to :account, Account

    timestamps()
  end

  def allowed_documents() do
    ["cpf", "rg", "passport", "cnpj"]
  end

  def create_changeset(account, attrs) do
    # verify all constraints
    %__MODULE__{}
    |> cast(attrs, @valid_attrs)
    |> put_assoc(:account, account)
    |> validate_required(@valid_attrs)
    |> unique_constraint(:document_id,
      name: :users_document_type_document_id_index,
      message: gettext("document_id should be unique for each document_type")
    )
    |> check_constraint(:birthdate,
      name: :user_most_have_more_than_18,
      message: gettext("should have more than 18 years old.")
    )
    |> hash_password
    |> put_email_verification_code
  end

  defp put_email_verification_code(changeset) do
    token = EmailVerification.random_token()
    changeset |> put_change(:email_verification_code, token)
  end

  defp hash_password(changeset) do
    case changeset.changes[:password] do
      nil -> changeset
      pw -> changeset |> put_change(:password_hash, Password.hash(pw))
    end
  end
end
