defmodule Banking.Bonus.FirstAccess do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Banking.AccountManagement.Account

  schema "bonus_first_access" do
    belongs_to :account, Account

    timestamps()
  end

  @doc false
  def create_changeset(account) do
    %__MODULE__{}
    |> change(%{})
    |> put_assoc(:account, account)
    |> unique_constraint(:account_id)
  end
end
