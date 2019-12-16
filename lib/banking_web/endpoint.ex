defmodule BankingWeb.Endpoint do
  @moduledoc """
  Defines Banking endpoint.

  The endpoint is the boundary where all requests to your
  web application start. It is also the interface your
  application provides to the underlying web servers.

  Overall, an endpoint has three responsibilities:

    * to provide a wrapper for starting and stopping the
      endpoint as part of a supervision tree

    * to define an initial plug pipeline for requests
      to pass through

    * to host web specific configuration for your
      application
  """

  use Phoenix.Endpoint, otp_app: :banking

  socket "/socket", BankingWeb.UserSocket,
    websocket: true,
    longpoll: false

  plug Plug.Static,
    at: "/",
    from: :banking,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug RemoteIp

  plug Plug.Session,
    store: :cookie,
    key: "_banking_key",
    signing_salt: "cL8AbpR6"

  plug BankingWeb.Router
end
