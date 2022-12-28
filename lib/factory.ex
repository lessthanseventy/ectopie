defmodule Ectoprint.Factory do
  use ExMachina.Ecto, repo: Ectoprint.Repo

  alias Ectoprint.Design.Card

  def card_factory do
    category = Faker.StarWars.En.character()

    %Card{
      category: category,
      description: Faker.StarWars.En.quote(),
      heading: Faker.StarWars.En.planet(),
      img_src: "https://cataas.com/cat/says/#{category}?t=small"
    }
    |> insert()
  end
end
