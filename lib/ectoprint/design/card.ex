defmodule Ectoprint.Design.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "design_cards" do
    field :category, :string
    field :description, :string
    field :heading, :string
    field :img_src, :string

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:category, :heading, :img_src, :description])
    |> validate_required([:category, :heading, :img_src, :description])
  end
end
