defmodule EctoprintWeb.NavigationLiveTest do
  use EctoprintWeb.LiveViewCase, async: false

  test "disconnected and connected mount", %{conn: conn} do
    {:ok, view, html} = conn |> live("/design")

    design_html =
      view
      |> element("a", "Control")
      |> render_click()

    # assert design_html =~ "Control Page"
  end
end
