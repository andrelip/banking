defmodule BankingWeb.GraphQL.Plugs.Pipeline do
  @moduledoc """
  Plug that performs a pipeline of guardian operations to parse the token from
  the Authorization header and load the resource if any
  """

  use Guardian.Plug.Pipeline,
    otp_app: :banking,
    error_handler: ComboWeb.GraphQL.SessionErrorHandler,
    module: Banking.Session.Guardian

  plug Guardian.Plug.VerifyHeader

  plug Guardian.Plug.LoadResource, allow_blank: true
end
