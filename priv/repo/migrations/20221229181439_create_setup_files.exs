defmodule Ectoprint.Repo.Migrations.CreateSetupFiles do
  use Ecto.Migration

  def change do
    create table(:setup_files) do
      add :filename, :string

      timestamps()
    end
  end
end
