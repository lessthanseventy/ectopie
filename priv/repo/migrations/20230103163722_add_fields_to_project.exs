defmodule Ectoprint.Repo.Migrations.AddFieldsToProject do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :last_printed, :utc_datetime
      add :filament_type, :text
      add :printer_head_speed, :text
      add :notes, :text
    end
  end
end
