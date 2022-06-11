defmodule CryptoEngine.Repo do
  use Ecto.Repo,
    otp_app: :crypto_engine,
    adapter: Ecto.Adapters.Postgres
end
