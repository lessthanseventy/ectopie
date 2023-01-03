defmodule EctoprintWeb.Router do
  use EctoprintWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {EctoprintWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :playground do
    plug(:put_layout, {EctoprintWeb.Layout, :playground})
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  get("/", EctoprintWeb.PageController, :redirect_to_design)

  scope "/", EctoprintWeb do
    pipe_through(:browser)

    scope "/design" do
      live("/", DesignLive, :design)
      live("/:pagination_page", DesignLive, :pagination)
    end

    scope "/setup" do
      live("/project", SetupLive, :setup)
      live("/project/:pagination_page", SetupLive, :pagination)
      live("/upload_files", SetupLive, :upload_files)
    end

    scope "/control" do
      live("/", ControlLive, :control)
    end

    scope "/monitor" do
      live("/", MonitorLive, :monitor)
    end

    scope "/review" do
      live("/", ReviewLive, :review)
    end

    get("/playground", PlaygroundController, :playground)

    scope "/playground/live" do
      live("/", PlaygroundLive, :playground_live)
      live("/modal/:size", PlaygroundLive, :modal)
      live("/slide_over/:origin", PlaygroundLive, :slide_over)
      live("/pagination/:page", PlaygroundLive, :pagination)
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", EctoprintWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ectoprint, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: EctoprintWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
