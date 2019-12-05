defmodule TestSchema do
  use Ecto.Schema

  schema "users" do
    field :name
  end
end

defmodule Banking.UtilsTest do
  use ExUnit.Case, async: true
  alias Banking.Utils

  test "#translate_errors with string keys" do
    types = %{
      email: :string,
      name: :string
    }

    errors = [
      name: {"can't be blank", [validation: :required]},
      email: {"can't be blank", [validation: :required]},
      password:
        {"should be at least %{count} character(s)",
         [count: 8, validation: :length, kind: :min, type: :string]}
    ]

    error_changeset = %Ecto.Changeset{types: types, errors: errors}

    assert Utils.translate_errors(error_changeset) == %{
             email: ["can't be blank"],
             name: ["can't be blank"],
             password: ["should be at least 8 character(s)"]
           }
  end
end
