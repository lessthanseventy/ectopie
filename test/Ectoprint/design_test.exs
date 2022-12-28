defmodule Ectoprint.DesignTest do
  use Ectoprint.DataCase

  alias Ectoprint.Design

  describe "design_cards" do
    alias Ectoprint.Design.Card

    import Ectoprint.DesignFixtures

    @invalid_attrs %{category: nil, description: nil, heading: nil, img_src: nil}

    test "list_design_cards/0 returns all design_cards" do
      card = card_fixture()
      assert Design.list_design_cards() == [card]
    end

    test "get_card!/1 returns the card with given id" do
      card = card_fixture()
      assert Design.get_card!(card.id) == card
    end

    test "create_card/1 with valid data creates a card" do
      valid_attrs = %{category: "some category", description: "some description", heading: "some heading", img_src: "some img_src"}

      assert {:ok, %Card{} = card} = Design.create_card(valid_attrs)
      assert card.category == "some category"
      assert card.description == "some description"
      assert card.heading == "some heading"
      assert card.img_src == "some img_src"
    end

    test "create_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Design.create_card(@invalid_attrs)
    end

    test "update_card/2 with valid data updates the card" do
      card = card_fixture()
      update_attrs = %{category: "some updated category", description: "some updated description", heading: "some updated heading", img_src: "some updated img_src"}

      assert {:ok, %Card{} = card} = Design.update_card(card, update_attrs)
      assert card.category == "some updated category"
      assert card.description == "some updated description"
      assert card.heading == "some updated heading"
      assert card.img_src == "some updated img_src"
    end

    test "update_card/2 with invalid data returns error changeset" do
      card = card_fixture()
      assert {:error, %Ecto.Changeset{}} = Design.update_card(card, @invalid_attrs)
      assert card == Design.get_card!(card.id)
    end

    test "delete_card/1 deletes the card" do
      card = card_fixture()
      assert {:ok, %Card{}} = Design.delete_card(card)
      assert_raise Ecto.NoResultsError, fn -> Design.get_card!(card.id) end
    end

    test "change_card/1 returns a card changeset" do
      card = card_fixture()
      assert %Ecto.Changeset{} = Design.change_card(card)
    end
  end
end
