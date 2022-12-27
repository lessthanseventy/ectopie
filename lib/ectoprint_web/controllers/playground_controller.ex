defmodule EctoprintWeb.PlaygroundController do
  use EctoprintWeb, :controller

  def index(conn, _params) do
    render(conn, :index, active_tab: :home)
  end
end
