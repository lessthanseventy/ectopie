defmodule Ectoprint.Repo do
  use Ecto.Repo,
    otp_app: :ectoprint,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 8
end
