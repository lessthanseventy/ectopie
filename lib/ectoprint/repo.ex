defmodule Ectoprint.Repo do
  use Ecto.Repo,
    otp_app: :Ectoprint,
    adapter: Ecto.Adapters.Postgres
end
