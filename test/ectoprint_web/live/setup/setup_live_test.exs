defmodule EctoprintWeb.SetupLiveTest do
  use EctoprintWeb.LiveViewCase, async: false

  test "upload files modal displays and closes", %{conn: conn} do
    {:ok, view, html} = conn |> live("/setup/upload_files")

    assert view
           |> has_element?("#modal")

    assert html =~ "Select files"

    refute view
           |> render_click(:close_modal) =~ "Select files"
  end
end
