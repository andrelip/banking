bank_reserves =
  %Banking.AccountManagement.Account{
    id: 1,
    public_id: Ecto.UUID.generate(),
    balance: Decimal.new(100_000_000_000),
    status: "special"
  }
  |> Banking.Repo.insert!()

cashout_register =
  %Banking.AccountManagement.Account{
    id: 2,
    public_id: Ecto.UUID.generate(),
    balance: Decimal.new(0),
    status: "special"
  }
  |> Banking.Repo.insert!()

fees_register =
  %Banking.AccountManagement.Account{
    id: 3,
    public_id: Ecto.UUID.generate(),
    balance: Decimal.new(0),
    status: "special"
  }
  |> Banking.Repo.insert!()

# only dev
sample_account1 =
  %Banking.AccountManagement.Account{
    id: 4,
    public_id: Ecto.UUID.generate(),
    balance: Decimal.new(1000),
    status: "active"
  }
  |> Banking.Repo.insert!()

sample_account2 =
  %Banking.AccountManagement.Account{
    id: 5,
    public_id: Ecto.UUID.generate(),
    balance: Decimal.new(1000),
    status: "active"
  }
  |> Banking.Repo.insert!()
