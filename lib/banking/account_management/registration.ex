defmodule Banking.AccountManagement.Registration do
  use Ecto.Schema
  import Ecto.Changeset

  alias Banking.Repo
  alias Banking.AccountManagement.Account
  alias Banking.AccountManagement.User
  import Banking.AccountManagement.UserValidation

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

  def insert(attrs) do
    changeset = create_changeset(attrs)

    if changeset.valid? do
      case Repo.transaction(to_multi(attrs)) do
        {:ok, structs} ->
          {:ok, structs}

        {:error, _operation, repo_changeset, _changes} ->
          {:error, copy_errors(repo_changeset, changeset)}
      end
    else
      {:error, changeset}
    end
  end

  defp copy_errors(from, to) do
    Enum.reduce(from.errors, to, fn {field, {msg, additional}}, acc ->
      Ecto.Changeset.add_error(acc, field, msg, additional: additional)
    end)
  end

  def create_changeset(attrs), do: changeset(%__MODULE__{}, attrs)

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

  defp to_multi(params \\ %{}) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:account, Account.create_changeset())
    |> Ecto.Multi.insert(:user, fn %{account: account} ->
      params = params |> Map.put(:pending_email, params[:email])
      User.create_changeset(account, params)
    end)
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
