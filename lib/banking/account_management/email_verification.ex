defmodule Banking.AccountManagement.EmailVerification do
  def random_token(length \\ 64) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end
end
