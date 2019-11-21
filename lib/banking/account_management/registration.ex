defmodule Banking.Accountmanagement.Registration do
  use Ecto.Schema
  import Ecto.Changeset

  import Banking.Accounts.UserValidation

  @required_fields [:name, :email, :password, :birthdate, :document_id, :document_type]

  @primary_key false
  embedded_schema do
    field :name, :string
    field :email, :string
    field :password, :string
    field :birthdate, :date
    field :document_id, :string
    field :document_type, :string
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_email
    |> validate_name
    |> validate_document_id
    |> validate_document_type
    |> validate_birthdate(18)
  end

  # def register_user(params) do
  #   chset = changeset(%Registration{}, params)

  #   Multi.new()
  #   |> Multi.run(:registration, &apply_registration(&1, chset))
  #   |> Multi.run(:user, fn ops ->
  #     Repo.insert(to_user_changeset(%User{}, ops.registration))
  #   end)
  #   |> Repo.transaction()
  # end
end
