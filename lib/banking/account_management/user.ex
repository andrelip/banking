defmodule Banking.AccountManagement.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Banking.AccountManagement.Account

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
    belongs_to :account, Account

    timestamps()
  end

  def allowed_documents() do
    ["cpf", "rg", "passport", "cnpj"]
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @valid_attrs)
    |> validate_required(@valid_attrs)
  end
end
