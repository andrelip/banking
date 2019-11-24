alias Banking.Repo
alias Banking.AccountManagement.User
import Ecto.Query
import Ecto.Changeset, only: [change: 2]

user = from(u in User, order_by: [asc: u.id], preload: [:account], limit: 1) |> Repo.one()
