%Banking.AccountManagement.Account{
  id: 1,
  public_id: Ecto.UUID.generate(),
  balance: Decimal.new(1000),
  status: "active"
}
|> Banking.Repo.insert!()

%Banking.AccountManagement.Account{
  id: 2,
  public_id: Ecto.UUID.generate(),
  balance: Decimal.new(1000),
  status: "active"
}
|> Banking.Repo.insert!()
