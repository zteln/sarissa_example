defmodule SarissaExample.Repo do
  use Ecto.Repo,
    otp_app: :sarissa_example,
    adapter: Ecto.Adapters.Postgres
end
