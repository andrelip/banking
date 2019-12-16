defmodule BankingWeb.GraphQL.Schema do
  @moduledoc """
  Defines the main GraphQL's schema used by absinthe.
  """

  use Absinthe.Schema
  alias Banking.AccountManagement.Resolver, as: AccountsManagementResolver
  alias Banking.Admin
  alias Banking.Bank.Resolver, as: BankResolver
  alias Banking.Session.Resolver, as: SessionResolver

  import_types(Absinthe.Type.Custom)
  import_types(Banking.GraphQL.CommonTypes)
  import_types(Banking.GraphQL.SignUpTypes)
  import_types(Banking.GraphQL.BankKPITypes)

  query do
    field :me, :user do
      resolve(&AccountsManagementResolver.me/2)
    end

    field :transactions_kpi, :bank_kpi do
      arg(:key, non_null(:string))

      resolve(fn %{key: key}, _ ->
        case Admin.verify_admin_key(key) do
          true -> {:ok, %{}}
          false -> {:error, "wrong key"}
        end
      end)
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

    field :transfer, :boolean do
      arg(:target_account_public_id, :string)
      arg(:amount, :integer)

      resolve(&BankResolver.transfer/2)
    end

    field :withdrawal, :boolean do
      arg(:amount, :integer)

      resolve(&BankResolver.withdrawal/2)
    end

    field :sign_in, :string do
      arg(:email, :string)
      arg(:password, :string)

      resolve(&SessionResolver.sign_in/2)
    end
  end
end
