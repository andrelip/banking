defmodule BankingWeb.GraphQL.Plugs.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :banking,
    error_handler: ComboWeb.GraphQL.SessionErrorHandler,
    module: Banking.Session.Guardian

  plug Guardian.Plug.VerifyHeader

  plug Guardian.Plug.LoadResource, allow_blank: true
end
