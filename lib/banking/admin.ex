defmodule Banking.Admin do
  @moduledoc """
  Handles the Admin operations.

  This is an early implementation that handles those limited features provided
  in this module. It should be improved and moved to the database to implement
  TTL keys and make it more dynamic allowing multiple accounts and other features.
  """

  @doc """
  Fetches the key in runtime

  ## Example

      iex> Banking.Admin.key_hash
      "$argon2id$v=19$m=131072,t=8,p=4$plCNd79nNxwu4a5o3EifHw$50tu+BNSVl/SvojDW"
  """
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
  def verify_admin_key(key) do
    Argon2.verify_pass(key, key_hash())
  end
end
