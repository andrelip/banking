defmodule Banking.Repo.Migrations.CreateBonusFirstAccess do
  use Ecto.Migration

  def change do
    create table(:bonus_first_access) do
      add :account_id, references(:accounts, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:bonus_first_access, [:account_id])
  end
end
