defmodule Ectoprint.ProjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ectoprint.Projects` context.
  """

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(%{
        description: "some description",
        file_upload: "some file_upload"
      })
      |> Ectoprint.Projects.create_project()

    project
  end
end
