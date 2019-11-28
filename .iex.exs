alias Banking.Repo
alias Banking.AccountManagement.Account
alias Banking.Bank
import Ecto.Query
import Ecto.Changeset, only: [change: 2]

a1 = Repo.get(Account, 1)
a2 = Repo.get(Account, 2)
