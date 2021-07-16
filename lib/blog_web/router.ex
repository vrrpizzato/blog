defmodule BlogWeb.Router do
  use BlogWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # coveralls-ignore-start
  pipeline :api do
    plug :accepts, ["json"]
  end

  # coveralls-ignore-stop

  scope "/", BlogWeb do
    pipe_through :browser

    # METHOD    RESOURCE       MODULE         FUNCTION

    # get "/posts", PostController, :index
    # post "/posts/", PostController, :create
    # get "/posts/:id/edit", PostController, :edit
    # put "/posts/:id", PostController, :update
    # delete "/posts/:id", PostController, :delete
    # get "/posts/new", PostController, :new
    # get "/posts/:id", PostController, :show

    resources "/posts", PostController

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", BlogWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).

  # coveralls-ignore-start
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: BlogWeb.Telemetry
    end
  end

  # coveralls-ignore-stop
end
