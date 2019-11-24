defmodule Banking.AccountManagement.UserValidation do
  @moduledoc false

  import BankingWeb.Gettext
  import Ecto.Changeset

  alias Banking.AccountManagement.User

  def validate_email(changeset, key \\ :email) do
    changeset
    |> validate_format(key, ~r/@/)
    |> validate_length(key, min: 5, max: 320)
  end

  def validate_name(changeset) do
    changeset
    |> validate_format(:name, ~r/\s/, message: gettext("Fullname is required"))
    |> validate_length(:name, min: 5, max: 500)
  end

  def validate_document_id(changeset) do
    changeset
    |> validate_length(:document_id, min: 5, max: 30)
  end

  def validate_document_type(changeset) do
    allowed_documents = User.allowed_documents()

    changeset
    |> validate_inclusion(:document_type, allowed_documents)
  end

  def validate_password(changeset) do
    changeset
    |> validate_length(:password, min: 8, max: 128)
    |> validate_format(:password, ~r/[0-9]+/, message: gettext("Password must contain a number"))
    |> validate_format(:password, ~r/[A-Z]+/,
      message: gettext("Password must contain an upper-case letter")
    )
    |> validate_format(:password, ~r/[a-z]+/,
      message: gettext("Password must contain a lower-case letter")
    )
    |> validate_format(:password, ~r/[#\!\?&@\$%^&*\(\)]+/,
      message: gettext("Password must contain a symbol")
    )
  end

  def validate_birthdate(%Ecto.Changeset{changes: %{birthdate: birthdate}} = changeset, age) do
    minimum_date = Timex.today() |> Timex.shift(years: -age)

    case Date.compare(birthdate, minimum_date) do
      :gt ->
        add_error(
          changeset,
          :birth_date,
          gettext("should have more than %{age} years old.", age: age)
        )

      _ ->
        changeset
    end
  end

  def validate_birthdate(changeset, _age), do: changeset
end
