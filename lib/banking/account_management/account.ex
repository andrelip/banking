defmodule Banking.AccountManagement.Account do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Banking.AccountManagement.User

  @type t :: %__MODULE__{
          public_id: String.t(),
          status: String.t(),
          balance: Decimal.t()
        }

  schema "accounts" do
    field :public_id, Ecto.UUID
    field :status, :string
    field :balance, :decimal
    has_one :user, User

    timestamps()
  end

  def create_changeset do
    %__MODULE__{}
    |> change(%{})
    |> put_public_id
    |> put_default_status
    |> put_change(:balance, 0)
  end

  defp put_public_id(changeset) do
    changeset |> put_change(:public_id, Ecto.UUID.generate())
  end

  defp put_default_status(changeset) do
    changeset |> put_change(:status, "pending")
  end
end
