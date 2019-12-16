defmodule Banking.GraphQL.CommonTypes do
  @moduledoc false

  use Absinthe.Schema.Notation

  scalar :raw_json do
    serialize(& &1)
  end

  object :validation_errors do
    field :errors, list_of(:validation_error)
  end

  object :validation_error do
    field :field, :string
    field :message, :string
  end

  object :user do
    field :name, :string
    field :email, :string
    field :pending_email, :string
    field :birthdate, :string
    field :account, :account
  end

  object :account do
    field :public_id, :string
  end
end
