defmodule Ectoprint.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :description, :string
    field :file_upload, :string

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:file_upload, :description])
    |> validate_required([:file_upload, :description])
  end
end
