defmodule Binance.APIBehaviour do
  @callback get_single_live_ticker_price(String.t()) :: map()
end
