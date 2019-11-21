defmodule Banking.Accountmanagement.Password do
  def hash(raw_password) do
    Argon2.hash_pwd_salt(raw_password)
  end

  def verify_password(raw_password, encrypted_password) do
    Argon2.verify_pass(raw_password, encrypted_password)
  end
end
