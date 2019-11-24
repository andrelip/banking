defmodule Banking.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :public_id, :uuid, null: false
      add :status, :string, null: false

      timestamps()
    end

    create unique_index(:accounts, [:public_id])
    create index(:accounts, [:status])
  end
end
