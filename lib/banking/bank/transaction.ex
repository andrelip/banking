defmodule Banking.Bank.Transaction do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.UUID

  @required_params [:amount, :source_id, :target_id]
  @timestamps_opts [type: :utc_datetime_usec]

  schema "bank_transactions" do
    field :amount, :decimal
    field :source_id, :id
    field :target_id, :id
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
