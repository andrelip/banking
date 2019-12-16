defmodule Banking.GraphQL.BankKPITypes do
  @moduledoc false

  use Absinthe.Schema.Notation

  alias Banking.Bank.KPI.Resolver

  object :bank_kpi do
    field :sum_total, :decimal do
      async(fn ->
        resolve(&Resolver.transactions_sum/2)
      end)
    end

    field :sum_current_month, :decimal do
      async(fn ->
        resolve(&Resolver.transactions_sum_current_month/2)
      end)
    end

    field :sum_previous_month, :decimal do
      async(fn ->
        resolve(&Resolver.transactions_sum_previous_month/2)
      end)
    end

    field :sum_current_year, :decimal do
      async(fn ->
        resolve(&Resolver.transactions_sum_current_year/2)
      end)
    end

    field :sum_previous_year, :decimal do
      async(fn ->
        resolve(&Resolver.transactions_sum_previous_year/2)
      end)
    end

    field :sum_past_days, :decimal do
      arg(:days, non_null(:integer))

      async(fn ->
        resolve(&Resolver.transactions_sum_past_days/2)
      end)
    end
  end
end
