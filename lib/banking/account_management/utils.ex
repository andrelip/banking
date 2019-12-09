defmodule Banking.Utils do
  @moduledoc false

  alias Ecto.Changeset

  def translate_errors(changeset) do
    Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end

  def inline_errors(changeset) do
    changeset
    |> translate_errors
    |> Enum.map(fn {field, msg} -> "#{String.capitalize(Atom.to_string(field))} #{msg}" end)
    |> Enum.join("/n")
  end
end
