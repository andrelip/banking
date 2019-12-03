defmodule Banking.Session do
  alias Banking.Session.SessionSchema
  alias Banking.Repo

  import Ecto.Query

  def create(user, ip_address, opts \\ %{}) do
    changeset = SessionSchema.create_changeset(user, ip_address, opts)
    Repo.insert(changeset)
  end

  def get(session_id) do
    from(s in SessionSchema,
      where: s.id == ^session_id,
      order_by: [desc: :id],
      limit: 1,
      preload: [:user]
    )
    |> Repo.one()
  end
end
