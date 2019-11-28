defmodule Banking.Repo.Migrations.AddPublicIdToTransaction do
  use Ecto.Migration

  def change do
    alter table(:bank_transactions) do
      add(:public_id, :uuid)
    end
  end
end
