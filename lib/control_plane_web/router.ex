defmodule ControlPlaneWeb.Router do
  use ControlPlaneWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ControlPlaneWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ControlPlaneWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/sources", SourceLive.Index, :index
    live "/sources/new", SourceLive.Form, :new
    live "/sources/:id", SourceLive.Show, :show
    live "/sources/:id/edit", SourceLive.Form, :edit
  end

  scope "/rss", ControlPlaneWeb do
    pipe_through :browser

    live "/sources", SourceLive.Index, :index
    live "/sources/new", SourceLive.Form, :new
    live "/sources/:id", SourceLive.Show, :show
    live "/sources/:id/edit", SourceLive.Form, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", ControlPlaneWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:control_plane, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ControlPlaneWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
