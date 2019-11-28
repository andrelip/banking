defmodule Banking.Repo.Migrations.CreateBankTransactions do
  use Ecto.Migration

  def change do
    create table(:bank_transactions) do
      add :amount, :decimal, precision: 19, scale: 4, null: false
      add :source_id, references(:accounts, on_delete: :nothing), null: false
      add :target_id, references(:accounts, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:bank_transactions, [:source_id])
    create index(:bank_transactions, [:target_id])
  end
end
