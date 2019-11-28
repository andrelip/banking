alias Banking.Repo
alias Banking.AccountManagement.Account
alias Banking.AccountManagement.User
alias Banking.Bank
alias Banking.Bank.Transaction
import Ecto.Query
import Ecto.Changeset, only: [change: 2]

a1 = Repo.get(Account, 4)
a2 = Repo.get(Account, 5)
