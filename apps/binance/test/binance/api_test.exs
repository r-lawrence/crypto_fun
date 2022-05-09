defmodule Binance.APITest do
  use ExUnit.Case, async: true

  @binance_service Application.get_env(:binance, :binance_service)
  @mock_resp_price 35250

  describe "get_single_live_ticket_price" do
    test "given valid binance crypto API symbol, returns a coin specific response body decoded" do
      assert %{"price" => @mock_resp_price, "symbol" => "BTCUSD"} ==
               @binance_service.get_single_live_ticker_price("BTCUSD")

      assert %{"price" => @mock_resp_price, "symbol" => "ETHUSD"} ==
               @binance_service.get_single_live_ticker_price("ETHUSD")

      assert %{"price" => @mock_resp_price, "symbol" => "RVNUSD"} ==
               @binance_service.get_single_live_ticker_price("RVNUSD")
    end
  end
end
