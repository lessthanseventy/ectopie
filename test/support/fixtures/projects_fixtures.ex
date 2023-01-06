defmodule Ectoprint.ProjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ectoprint.Projects` context.
  """
  alias Faker.Superhero

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(%{
        file_upload: "#{Superhero.name()}.stl",
        description: Superhero.descriptor()
      })
      |> Ectoprint.Projects.create_project()

    project
  end
end
