defmodule Banking.Bank.Seeds do
  @moduledoc false

  alias Banking.AccountManagement.Account
  alias Banking.Repo

  def coldstart do
    production()

    case Application.get_env(:banking, :environment) do
      :dev ->
        dev_only()

      _ ->
        nil
    end

    # Adjust the sequence position since we are hardcoding the id
    count = Repo.aggregate(Account, :count, :id)
    Repo.query("SELECT setval('accounts_id_seq', #{count}, true);")
  end

  defp production do
    _bank_reserves = create_account(1, 1_000_000_000_000)
    _cashout = create_account(2, 0)
    _fee_register = create_account(3, 0)
  end

  defp dev_only do
    _sample_account1 = create_account(4, 1_000, "active")
    _sample_account2 = create_account(5, 1_000, "active")
  end

  def create_account(id, ammount, type \\ "special") do
    %Account{
      id: id,
      public_id: Ecto.UUID.generate(),
      balance: Decimal.new(ammount),
      status: type
    }
    |> Banking.Repo.insert!()
  end
end
