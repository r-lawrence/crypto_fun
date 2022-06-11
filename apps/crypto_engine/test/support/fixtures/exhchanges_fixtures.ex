defmodule CryptoEngine.ExhchangesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CryptoApi.Exhchanges` context.
  """

  @doc """
  Generate a binance.
  """
  def binance_fixture(attrs \\ %{}) do
    {:ok, binance} =
      attrs
      |> Enum.into(%{
        current_price_data: %{"BTCUSD" => [%{"price" => "33250", "time" => Time.utc_now()}], "ETHBTC" => [%{"price" => "111", "time" => Time.utc_now()}]},
        date: ~D[2022-05-14],
        id: "7488a646-e31f-11e4-aace-600308960662",
        current_symbols: %{
          "BTC" => ["ETHBTC"],
          "USD" => ["BTCUSD"],
          "USDT" => ["FILUSDT"]
        }
      })
      |> CryptoEngine.Exchanges.create_binance()

  binance
  end
end
