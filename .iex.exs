alias Banking.Repo
alias Banking.AccountManagement.Account
alias Banking.AccountManagement.User
alias Banking.Bank
alias Banking.Bank.Transaction
import Ecto.Query
import Ecto.Changeset, only: [change: 2]

u1 = Repo.get(User, 1) |> Repo.preload([:account])
