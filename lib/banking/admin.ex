defmodule Banking.Admin do
  @moduledoc """
  Handles the Admin operations.

  Currently just a placeholder with simple hardcoded key.
  """

  def key_hash do
    Application.get_env(:banking, Banking.Admin)[:key_hash]
  end

  def verify_admin_key(key) do
    Argon2.verify_pass(key, key_hash())
  end
end
