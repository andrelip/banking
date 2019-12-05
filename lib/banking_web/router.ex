defmodule BankingWeb.Router do
  use BankingWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :graphql do
    plug :accepts, ["json"]
    plug BankingWeb.GraphQL.Plugs.Pipeline
    plug BankingWeb.GraphQL.Plugs.Context
  end

  scope "/" do
    pipe_through :graphql

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: BankingWeb.GraphQL.Schema
    forward "/graphql", Absinthe.Plug, schema: BankingWeb.GraphQL.Schema
  end

  scope "/", BankingWeb do
    pipe_through :browser

    get "/", PageController, :index
  end
end
