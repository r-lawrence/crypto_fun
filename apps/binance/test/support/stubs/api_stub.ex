defmodule Binance.APIStub do
  @behaviour Binance.APIBehaviour

  def get_single_live_ticker_price(symbol) do
    %{"symbol" => symbol, "price" => 35250}
  end
end
