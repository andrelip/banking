defmodule Banking.Session do
  @moduledoc """
  Handles the user session by tracking the IP and device used.

  Here you can put extra behaviors like controlling simultaneous sessions.
  """
  alias Banking.AccountManagement.User
  alias Banking.Repo
  alias Banking.Session.Guardian
  alias Banking.Session.SessionSchema

  import Ecto.Query

  @type jwt :: String.t()
  @type session_opts ::
          %{
            device_type: String.t(),
            device_id: String.t()
          }
          | %{}

  @doc """
  Creates a session for a given user and returns token and claims

  ## Example:

      iex> Banking.Session.create_jwt(user, "127.0.0.1", device_type: "android", device_id: "1231...")
      {:ok, "jwt...",  %{
        "aud" => "banking",
        "exp" => 1576646266,
        "iat" => 1576473466,
        "iss" => "banking",
        "jti" => "40bf6667-dca9-42b2-92ab-461cfd9c7a67",
        "nbf" => 1576473465,
        "sub" => "3942",
        "typ" => "access"
      }}
  """
  @spec create_jwt(User.t(), SessionSchema.ip(), session_opts()) :: {:ok, jwt(), map()}
  def create_jwt(user, ip_address, opts \\ %{}) do
    with {:ok, session} <- create(user, ip_address, opts) do
      to_jwt(session)
    end
  end

  @doc """
  Generates Jason Web Token and claims from an existing session

  ## Example:

      iex> Banking.Session.to_jwt(session)
      {:ok, "jwt...",  %{
        "aud" => "banking",
        "exp" => 1576646266,
        "iat" => 1576473466,
        "iss" => "banking",
        "jti" => "40bf6667-dca9-42b2-92ab-461cfd9c7a67",
        "nbf" => 1576473465,
        "sub" => "3942",
        "typ" => "access"
      }}
  """
  @spec to_jwt(SessionSchema.t()) :: {:ok, jwt(), map()}
  def to_jwt(session) do
    session |> Guardian.encode_and_sign()
  end

  @doc """
  Creates a session for a given user

  ## Example:

      iex> Banking.Session.create(user, "127.0.0.1", device_type: "android", device_id: "1231...")
      {:ok, %Banking.Session.SessionSchema{...}}
  """
  @spec create(User.t(), SessionSchema.ip(), session_opts()) ::
          {:ok, SessionSchema.t()} | {:error, Ecto.Changeset.t()}
  def create(user, ip_address, opts \\ %{}) do
    changeset = SessionSchema.create_changeset(user, ip_address, opts)
    Repo.insert(changeset)
  end

  @doc """
  Get session by id

  ## Example:

      iex> Banking.Session.get(1)
      %Banking.Session.SessionSchema{...}

      iex> Banking.Session.get(1000)
      nil
  """
  @spec get(integer()) :: SessionSchema.t() | nil
  def get(session_id) do
    from(s in SessionSchema,
      where: s.id == ^session_id,
      order_by: [desc: :id],
      limit: 1,
      preload: [user: :account]
    )
    |> Repo.one()
  end
end
