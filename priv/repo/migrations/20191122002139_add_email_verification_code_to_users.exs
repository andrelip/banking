defmodule Banking.Repo.Migrations.AddEmailVerificationCodeToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:email_verification_code, :string)
    end

    create unique_index(:users, [:email_verification_code])
  end
end
