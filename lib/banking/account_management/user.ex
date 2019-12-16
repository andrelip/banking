defmodule Banking.AccountManagement.User do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset
  import BankingWeb.Gettext
  import Banking.AccountManagement.UserValidation

  alias Banking.AccountManagement.Account
  alias Banking.AccountManagement.EmailVerification
  alias Banking.AccountManagement.Password

  @type t :: %__MODULE__{
          birthdate: Date.t(),
          document_id: String.t(),
          document_type: String.t(),
          email: String.t(),
          name: String.t(),
          password: String.t(),
          password_hash: String.t(),
          pending_email: String.t(),
          email_verification_code: String.t(),
          account: Account.t()
        }

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

  def allowed_documents do
    ["cpf", "rg", "passport", "cnpj"]
  end

  # Here we are checking the constraints and avoiding duplications on validations
  # that are  already present on Registration
  def create_changeset(account, attrs) do
    # verify all constraints
    %__MODULE__{}
    |> cast(attrs, @valid_attrs)
    |> put_assoc(:account, account)
    |> validate_required(@valid_attrs)
    |> unique_constraint(:email)
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

  # changes that are available to the end user
  def public_changeset(user, attrs) do
    user
    |> cast(attrs, [:password, :birthdate])
    |> hash_password
    |> validate_birthdate(18)
    |> validate_password
    |> hash_password
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
