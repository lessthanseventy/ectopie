defmodule Ectoprint.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add(:file_upload, :string)

      timestamps()
    end
  end
end
