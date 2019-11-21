defmodule Banking.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :birthdate, :date, null: false
      add :password_hash, :string, null: false
      add :email, :string
      add :pending_email, :string
      add :document_type, :string, null: false
      add :document_id, :string, null: false
      add :account_id, references(:accounts, on_delete: :delete_all)

      timestamps()
    end

    create index(:users, [:account_id])
    create unique_index(:users, [:email])
    create unique_index(:users, [:document_type, :document_id])

    create constraint(:users, :user_most_have_more_than_18,
             check: "birthdate < (current_date - interval '18' year )"
           )
  end
end
