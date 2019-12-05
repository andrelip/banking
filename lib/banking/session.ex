defmodule Banking.Session do
  @moduledoc """
  Handles the User session by tracking the ip and devices used to sign in
  """
  alias Banking.Repo
  alias Banking.Session.Guardian
  alias Banking.Session.SessionSchema

  import Ecto.Query

  @doc """
  Creates a session for a given user and returns token and claims
  """
  def create_jwt(user, ip_address, opts \\ %{}) do
    with {:ok, session} <- create(user, ip_address, opts) do
      to_jwt(session)
    end
  end

  @doc """
  Generates an JWT token and claims from an existing session
  """
  def to_jwt(session) do
    session |> Guardian.encode_and_sign()
  end

  @doc """
  Creates a session for a given user
  """
  def create(user, ip_address, opts \\ %{}) do
    changeset = SessionSchema.create_changeset(user, ip_address, opts)
    Repo.insert(changeset)
  end

  @doc """
  Get session by id
  """
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
