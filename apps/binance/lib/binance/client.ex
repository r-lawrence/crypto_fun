defmodule Binance.Client do
  @moduledoc """
    the module responsible for establishing a process live ticket stream via
    the binance API live ticker rest endpoint.  It is possible to connect to
    a binance API price websocket live ticker...but because we just want a
    semi real time graph - the rest endpoint + genserver is used

    note:  the websocket live ticker is probably most helpful when creating
    custom algo to buy/sell currency at a specific price point.
  """
  use GenServer

  @binance_service Application.get_env(:binance, :binance_service)

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{coin: "BTCUSD"}, name: __MODULE__)
  end

  def init(state) do
    schedule_coin_fetch()

    {:ok, state}
  end

  def handle_info(:coin_fetch, %{coin: symbol} = state) do
    current_data =
      @binance_service.get_single_live_ticker_price(symbol) |> Map.put("time", Time.utc_now())

    schedule_coin_fetch()
    handle_cast({:push, current_data}, state)
  end

  def handle_cast({:push, current_data}, state) do
    case Map.get(state, :current_price) do
      nil ->
        {:noreply, Map.put(state, :current_price, [current_data])}

      current_state ->
        single_list = current_state ++ [current_data]

        {:noreply, Map.put(state, :current_price, single_list)}
    end
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  defp schedule_coin_fetch() do
    Process.send_after(self(), :coin_fetch, 5000)
  end
end

# below is the functionality to connect to a websocket that will push you live candlestick data
# the module needs to be renamed fa sho.... but can is different then the data fetching
# functionality for a single coin.  This a websocket for live candlestick data for 🙃
# defmodule Binance.Client do
#   use WebSockex
#   @stream_endpoint "wss://stream.binance.com:9443/stream?streams="

#   @spec start_link(list, any) :: {:error, any} | {:ok, pid}
#   def start_link(symbols, interval) do
#     last_symbol = List.last(symbols)
#     streams_url =
#       symbols
#       |> Enum.map(fn symbol ->
#         build_request_url(symbol, last_symbol, interval)
#         end)
#       |> Enum.join("")

#     WebSockex.start_link(
#       "#{@stream_endpoint}#{streams_url}",
#       __MODULE__,
#       nil
#     )
#   end

#   def handle_connect(_conn, state) do
#     IO.puts "Connected!"
#     {:ok, state}
#   end

#   def handle_frame({type, msg}, state) do
#     msg
#     |> Jason.decode!()
#     frame = {type, msg}
#     handle_cast({:send, frame}, state)
#     ## when msg is received and decoded, what do we want to do with it?
#     ## send to a redis cache to be stored?
#     ## how will cache be cleared and set up?

#     # IO.puts "Received Message - Type: #{inspect type} -- Message: #{inspect msg}"
#     {:ok, state}
#   end

#   def handle_cast({:send, {type, msg} = frame}, state) do
#     IO.puts "Sending #{type} frame with payload: #{msg}"
#     {:reply, frame, state}
#   end

#   defp build_request_url(symbol, last_symbol, interval) do
#     if symbol != last_symbol do
#       "#{symbol}@kline_#{interval}/"
#     else
#       "#{symbol}@kline_#{interval}"
#     end
#   end
# end
