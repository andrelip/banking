defmodule Banking.AccountManagement.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @statuses ["pending_registration", "active", "inative"]

  @type t :: %{
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
    |> validate_inclusion(:status, @statuses)
  end
end
