defmodule EctoprintWeb.PageController do
  use EctoprintWeb, :controller

  def redirect_to_design(conn, _params) do
    redirect(conn, to: "/design")
  end
end
