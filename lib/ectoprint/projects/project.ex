defmodule Ectoprint.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :description, :string
    field :file_upload, :string
    field :last_printed, :utc_datetime
    field :filament_type, :string
    field :printer_head_speed, :string
    field :notes, :string

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [
      :file_upload,
       :description,
      :printer_head_speed,
      :notes
    ])
    |> validate_required([:file_upload, :description])
  end
end
