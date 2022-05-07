defmodule Binance.Client do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end


  def init(state) do
    schedule_coin_fetch()
    {:ok, state}
  end

  def handle_info(:coin_fetch, %{coin: "ETHUSD"} = state) do

    current_data =
      "https://api.binance.us/api/v3/ticker/price?symbol=ETHUSD"
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> Jason.decode!()
    |> Map.put("time", Time.utc_now())


    schedule_coin_fetch()
    handle_cast({:push, current_data}, state)

  end

  def handle_info(:coin_fetch, %{coin: "RVNUSD"} = state) do

    current_data =
      "https://api.binance.us/api/v3/ticker/price?symbol=RVNUSD"
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> Jason.decode!()
    |> Map.put("time", Time.utc_now())

    schedule_coin_fetch()
    handle_cast({:push, current_data}, state)

  end

  def handle_info(:coin_fetch, state) do
    current_data =
      "https://api.binance.us/api/v3/ticker/price?symbol=BTCUSD"
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> Jason.decode!()
    |> Map.put("time", Time.utc_now())

    schedule_coin_fetch()
    handle_cast({:push, current_data}, state)

  end

  def handle_cast({:push, current_data}, state) do

    case Map.get(state, :current_price) do
      nil -> {:noreply, Map.put(state, :current_price,  [current_data])}
      current_state ->
        single_list = current_state ++ [current_data]

        {:noreply, Map.put(state, :current_price, single_list)}
    end

  end

  def handle_call(:get, _from, state) do

    {:reply, state, state}

  end

  def schedule_coin_fetch() do
    Process.send_after(self(), :coin_fetch, 5_000)

  end

end

# below is the functionality to connect to a websocket that will push you live candlestick data
# the module needs to be renamed fa sho. lol 🙃
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
