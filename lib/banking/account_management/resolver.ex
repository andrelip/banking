defmodule Banking.AccountManagement.Resolver do
  @moduledoc false

  alias Banking.AccountManagement
  alias Banking.AccountManagement.Registration

  import BankingWeb.ErrorHelpers, only: [translate_error: 1]

  def register(data, _) do
    registration_data = struct(%Registration{}, data)

    case AccountManagement.create(registration_data) do
      {:ok, %{user: user}} ->
        {:ok, user}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:ok, %{errors: translate(changeset.errors)}}
    end
  end

  defp translate(errors) do
    Enum.map(errors, fn {field, error} ->
      %{field: field, message: translate_error(error)}
    end)
  end
end
