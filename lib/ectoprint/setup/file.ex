defmodule Ectoprint.Setup.Files do
  use Ecto.Schema
  import Ecto.Changeset

  schema "setup_files" do
    field :filename, :string

    timestamps()
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, [:filename])
    |> validate_required([:filename])
  end
end
