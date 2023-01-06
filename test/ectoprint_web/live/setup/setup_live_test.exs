defmodule EctoprintWeb.SetupLiveTest do
  use EctoprintWeb.LiveViewCase, async: false

  alias Ectoprint.Projects.Project

  import Ectoprint.ProjectsFixtures

  test "upload files modal displays and closes", %{conn: conn} do
    {:ok, view, html} = conn |> live("/setup/upload_files")

    assert view
           |> has_element?("#modal")

    assert html =~ "Select files"

    refute view
           |> render_click(:close_modal) =~ "Select files"
  end

  test "setup page lists paginated projects", %{conn: conn} do
    projects = for _ <- 0..100, do: project_fixture()

    {:ok, view, html} = conn |> live("/setup/projects")

    expected_projects = Enum.take(projects, 8)
    next_eight = Enum.slice(projects, 9..16)

    Enum.map(expected_projects, fn %Project{id: project_id} ->
      assert view
             |> has_element?("#project-preview-component-#{project_id}")
    end)

    Enum.map(next_eight, fn %Project{id: project_id} ->
      refute view
             |> has_element?("#project-preview-component-#{project_id}")
    end)

    project = next_eight |> List.first()
    selector = "project-preview-component-#{project.id}"

    refute view |> render() =~ selector

    assert view
           |> element("#projects-pagination a")
           |> render_click() =~ selector
  end
end
