defmodule Ectoprint.Factory do
  use ExMachina.Ecto, repo: Ectoprint.Repo

  alias Ectoprint.Design.Card
  alias Ectoprint.Projects.Project
  alias Faker.StarWars.En, as: StarWars
  alias Faker.Superhero

  def card_factory do
    category = StarWars.character()

    %Card{
      category: category,
      description: StarWars.quote(),
      heading: StarWars.planet(),
      img_src: "https://cataas.com/cat/says/#{category}?t=small"
    }
    |> insert()
  end

  def project_factory do
    %Project{
      file_upload: "#{Superhero.name()}..stl",
      description: Superhero.descriptor()
    }
    |> insert()
  end
end
