defmodule EctoprintWeb.ClientsLive.Aide.ShowTest do
  use EctoprintWeb.LiveViewCase, async: false

  test "disconnected and connected mount", %{conn: conn} do
    {:ok, view, html} = conn |> live("/")

    design_html =
      view
      |> element("a", "Design")
      |> render_click()

    assert design_html =~ "Design Page"
  end
end
