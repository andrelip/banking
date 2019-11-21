defmodule Banking.AccountManagement.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Banking.AccountManagement.Account

  schema "users" do
    field :birthdate, :date
    field :document_id, :string
    field :document_type, :string
    field :email, :string
    field :name, :string
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
    |> cast(attrs, [
      :name,
      :birthdate,
      :password_hash,
      :email,
      :pending_email,
      :document_type,
      :document_id
    ])
    |> validate_required([
      :name,
      :birthdate,
      :password_hash,
      :email,
      :pending_email,
      :document_type,
      :document_id
    ])
  end
end
