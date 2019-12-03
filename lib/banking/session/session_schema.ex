defmodule Banking.Session.SessionSchema do
  alias Banking.AccountManagement.User

  use Ecto.Schema
  import Ecto.Changeset

  schema "sessions" do
    field :device_id, :string
    field :device_type, :string
    field :ip_address, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def create_changeset(user, ip_address, attrs) do
    %__MODULE__{}
    |> cast(attrs, [:device_id, :device_type, :ip_address])
    |> put_change(:user_id, user.id)
    |> put_change(:ip_address, ip_address)
  end
end
