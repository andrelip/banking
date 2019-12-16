defmodule Banking.Bank.Transaction do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Banking.AccountManagement.Account
  alias Ecto.UUID

  @required_params [:amount, :source_id, :target_id]
  @timestamps_opts [type: :utc_datetime_usec]

  @type t :: %__MODULE__{
          amount: Decimal.t(),
          source_id: integer(),
          target_id: integer(),
          public_id: Ecto.UUID.t()
        }

  schema "bank_transactions" do
    field :amount, :decimal
    belongs_to :source, Account, foreign_key: :source_id
    belongs_to :target, Account, foreign_key: :target_id
    field :public_id, UUID

    timestamps()
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @required_params)
    |> validate_required(@required_params)
    |> validate_number(:amount, greater_than: 0)
    |> put_change(:public_id, UUID.generate())
  end
end
