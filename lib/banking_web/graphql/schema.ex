defmodule BankingWeb.GraphQL.Schema do
  @moduledoc false

  use Absinthe.Schema
  alias Banking.AccountManagement.Resolver, as: AccountsManagementResolver
  alias Banking.Session.Resolver, as: SessionResolver

  import_types(Absinthe.Type.Custom)
  import_types(Banking.GraphQL.CommonTypes)
  import_types(Banking.GraphQL.SignUpTypes)

  query do
    field :example, :string do
      resolve(fn _, _ -> {:ok, "query placeholder"} end)
    end

    field :me, :user do
      resolve(&AccountsManagementResolver.me/2)
    end
  end

  mutation do
    field :create_account, :signup_result do
      arg(:name, :string)
      arg(:email, :string)
      arg(:password, :string)
      arg(:birthdate, :string)
      arg(:document_id, :string)
      arg(:document_type, :string)

      resolve(&AccountsManagementResolver.register/2)
    end

    field :sign_in, :string do
      arg(:email, :string)
      arg(:password, :string)

      resolve(&SessionResolver.sign_in/2)
    end
  end
end
