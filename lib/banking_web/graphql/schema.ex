defmodule BankingWeb.GraphQL.Schema do
  @moduledoc false

  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)

  query do
    field :example, :string do
      resolve(fn _, _ -> {:ok, "query placeholder"} end)
    end
  end

  mutation do
    field :mutation_test, :string do
      arg(:name, :string)

      resolve(fn data, _ -> {:ok, data[:name]} end)
    end
  end
end
