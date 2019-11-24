defmodule Banking.AccountManagement.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @statuses ["pending_registration", "active", "inative"]

  @type t :: %__MODULE__{
          public_id: String.t(),
          status: String.t()
        }

  schema "accounts" do
    field :public_id, Ecto.UUID
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:public_id, :status])
    |> validate_required([:public_id, :status])
  end

  def create_changeset() do
    %__MODULE__{}
    |> change(%{})
    |> put_public_id
    |> put_default_status
  end

  defp put_public_id(changeset) do
    changeset |> put_change(:public_id, Ecto.UUID.generate())
  end

  defp put_default_status(changeset) do
    changeset |> put_change(:status, "pending")
  end
end
