defmodule EctoprintWeb.PlaygroundController do
  use EctoprintWeb, :controller

  def playground(conn, _params) do
    render(conn, :playground, active_tab: :index)
  end
end
