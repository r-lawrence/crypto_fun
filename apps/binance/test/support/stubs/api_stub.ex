defmodule Binance.APIStub do
  @behaviour Binance.APIBehaviour
  @spec get_all_live_ticker_prices :: list()
  def get_all_live_ticker_prices do
    [
      %{"symbol" => "BTCUSD", "price" => "29086.4700"},
      %{"symbol" => "ETHBTC", "price" => "0.06770700"},
      %{"symbol" => "FILUSDT", "price" => "1974.75000000"}
    ]
  end
end
