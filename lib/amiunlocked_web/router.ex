defmodule AmiunlockedWeb.Router do
  use AmiunlockedWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug BasicAuth, use_config: {:amiunlocked, :auth}
    plug :accepts, ["json"]
  end

  scope "/", AmiunlockedWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/update", AmiunlockedWeb do
    pipe_through :api

    post "/", PageController, :update
  end

  # Other scopes may use custom stacks.
  # scope "/api", AmiunlockedWeb do
  #   pipe_through :api
  # end
end
