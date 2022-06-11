defmodule Binance.APITest do
  use ExUnit.Case, async: true

  @binance_service Application.get_env(:binance, :binance_service)
  @all_pricing_format [
    %{"symbol" => "BTCUSD", "price" => "29086.4700"},
    %{"symbol" => "ETHBTC", "price" => "0.06770700"},
    %{"symbol" => "FILUSDT", "price" => "1974.75000000"}
  ]

  describe "get_all_live_ticker_prices/0" do
    test "should return data matching the binance api all pricing format" do
      assert @all_pricing_format == @binance_service.get_all_live_ticker_prices()
    end

  end
end
