defmodule Banking.AccountManagement.Password do
  @moduledoc """
  Is responsible for hashing the original password and decoded it.

  It uses Argon2 under the hood for security and to prevent timing attack.
  """

  @doc """
  Receives a password and returns it's hash.

  You cannot revert a hash but can compare it with another one generated with the
  same text.

  ## Example

      iex> Banking.AccountManagement.Password.hash("supersecret")
      "$argon2id$v=19$m=131072,t=8,p=4$YJSen030heKRxvb8Le369g$G03KU"
  """
  def hash(raw_password) do
    Argon2.hash_pwd_salt(raw_password)
  end

  @doc """
  Receives a raw password and compare that with a previously generated hash.

  ## Examples

      iex> hash = Banking.AccountManagement.Password.hash("supersecret")
      iex> Banking.AccountManagement.Password.verify_password("supersecret", hash)
      true
      iex> hash = Banking.AccountManagement.Password.hash("bad_password", hash)
      false
  """
  def verify_password(raw_password, encrypted_password) do
    Argon2.verify_pass(raw_password, encrypted_password)
  end
end
