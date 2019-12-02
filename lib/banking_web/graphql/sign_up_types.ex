defmodule Banking.GraphQL.SignUpTypes do
  @moduledoc false

  use Absinthe.Schema.Notation

  alias Banking.AccountManagement.User

  union :signup_result do
    types([:validation_errors, :user])

    resolve_type(fn
      %User{}, _ ->
        :user

      _, _ ->
        :validation_errors
    end)
  end
end
