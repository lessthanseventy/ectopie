defmodule Ectoprint.Repo.Migrations.CreateDesignCards do
  use Ecto.Migration

  def change do
    create table(:design_cards) do
      add :category, :string
      add :heading, :string
      add :img_src, :string
      add :description, :text

      timestamps()
    end
  end
end
