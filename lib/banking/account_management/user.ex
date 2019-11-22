defmodule Banking.AccountManagement.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Banking.AccountManagement.Account
  alias Banking.Accountmanagement.Password
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

  def create_changeset(attrs, skip_validation: true) do
    %__MODULE__{}
    |> cast(attrs, @valid_attrs)
    |> validate_required(@valid_attrs)
    |> hash_password
    |> maybe_put_email_verification_code
  end

  defp maybe_put_email_verification_code(changeset) do
    case changeset.changes[:pending_email] do
      nil ->
        changeset

      _email ->
        token = EmailVerification.random_token()
        changeset |> put_change(:email_verification_code, token)
    end
  end

  def hash_password(changeset) do
    case changeset.changes[:password] do
      nil -> changeset
      pw -> changeset |> put_change(:password_hash, Password.hash(pw))
    end
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @valid_attrs)
    |> validate_required(@valid_attrs)
  end
end
