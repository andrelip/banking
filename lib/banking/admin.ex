defmodule Banking.Admin do
  @moduledoc """
  Provides the functions to verify admin identity.
  """
  # This is a basic and limited implementation for our limited needs.
  # You should consider moving to a database implementation if the application
  # complexity grows.

  @doc """
  Fetches the key in runtime

  ## Example

      iex> Banking.Admin.key_hash
      "$argon2id$v=19$m=131072,t=8,p=4$plCNd79nNxwu4a5o3EifHw$50tu+BNSVl/SvojDW"
  """
  @spec key_hash :: String.t()
  def key_hash do
    Application.get_env(:banking, Banking.Admin)[:key_hash]
  end

  @doc """
  Verifies if the given key matches the admin key.

  It uses argon2 for security and to avoid timing attacks.


  ## Example

      iex> key = "$argon2id$v=19$m=131072,t=8,p=4$plCNd79nNxwu4a5o3EifHw$50tu+BNSVl/SvojDW"
      iex> Banking.Admin.verify_admin_key(key)
      true
      iex> Banking.Admin.verify_admin_key("badkey")
      false
  """
  @spec verify_admin_key(String.t()) :: boolean()
  def verify_admin_key(key) do
    Argon2.verify_pass(key, key_hash())
  end
end
