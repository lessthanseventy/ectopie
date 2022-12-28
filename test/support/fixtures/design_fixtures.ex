defmodule Ectoprint.DesignFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ectoprint.Design` context.
  """

  @doc """
  Generate a card.
  """
  def card_fixture(attrs \\ %{}) do
    {:ok, card} =
      attrs
      |> Enum.into(%{
        category: "some category",
        description: "some description",
        heading: "some heading",
        img_src: "some img_src"
      })
      |> Ectoprint.Design.create_card()

    card
  end
end
