defmodule Banking.Repo.Migrations.AddBalanceToAccount do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :balance, :decimal, precision: 19, scale: 4, null: false, default: 0
    end

    create constraint(:accounts, :balance_should_be_positive, check: "balance >= 0")
  end
end
