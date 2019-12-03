defmodule Banking.Session do
  alias Banking.Repo
  alias Banking.Session.Guardian
  alias Banking.Session.SessionSchema

  import Ecto.Query

  def create_jwt(user, ip_address, opts \\ %{}) do
    with {:ok, session} <- create(user, ip_address, opts) do
      to_jwt(session)
    end
  end

  def to_jwt(session) do
    session |> Guardian.encode_and_sign()
  end

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
