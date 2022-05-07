defmodule CryptoTraderWeb.PageController do
  use CryptoTraderWeb, :controller

  # alias Binance.Client

  def index(conn, _params) do
    # Client.start_link(["ethusdt", "btcusdt"], "1m") |> IO.inspect()

    render(conn, "index.html")
  end

  # def live_chart(conn, _params) do
  #   render(conn, "live_chart.html")
  # end
end
