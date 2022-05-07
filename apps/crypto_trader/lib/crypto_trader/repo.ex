defmodule CryptoTrader.Repo do
  use Ecto.Repo,
    otp_app: :crypto_trader,
    adapter: Ecto.Adapters.Postgres
end
