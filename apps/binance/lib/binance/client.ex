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

  @binance_service Application.get_env(:binance, Binance.API)[:binance_service]
  def start_link() do
    GenServer.start_link(__MODULE__, %{pricing: :not_loaded}, name: __MODULE__)
  end

  def init(state) do

    schedule_coin_fetch()

    {:ok, state}
  end



  def handle_info(:coin_fetch, state) do

    current_data =
      @binance_service.get_all_live_ticker_prices()

    format_and_save(current_data)
    ## transform the data
    ## save or update the database record


    {:noreply, Map.replace(state, :pricing, :updated)}
    # schedule_coin_fetch()
    # handle_cast({:push, current_data}, state)
  end


  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  defp format_and_save(current_data_list) do

    db_configured_map =
      Enum.map(current_data_list, fn current_map ->
        convert_to_list_of_maps(current_map)
      end)
      |> Enum.reduce(fn x, y ->
          Map.merge(x, y, fn _k, v1, v2 -> v2 ++ v1 end)
      end)

    db_configured_symbols = configure_and_save_symbols(db_configured_map)

    current_db_data = CryptoApi.Exhchanges.list_binance_pricing()

    if current_db_data == [] do
      attrs = %{current_price_data: db_configured_map, date: Date.utc_today(), current_symbols: db_configured_symbols}

      CryptoApi.Exhchanges.create_binance(attrs)
    else

      update_db_data(current_db_data, db_configured_map)

    end
    schedule_coin_fetch()
  end

  defp configure_and_save_symbols(map) do
   only_symbols = map |> Map.keys()

  usd = get_symbols_from_list(only_symbols, "USD")
  usdt = get_symbols_from_list(only_symbols, "SDT")
  btc = get_symbols_from_list(only_symbols, "BTC")

  %{"USD" => usd, "USDT" => usdt, "BTC" => btc}

  end

  defp get_symbols_from_list(list, currency) do
    Enum.reduce(list,[], fn(x, accum) ->
      add_matching_symbols(x, accum, currency)
    end) |> Enum.sort(:asc)
  end


  defp add_matching_symbols(current_symbol, accum, currency) do
    str_len = String.length(current_symbol)
    new_string = String.to_charlist(current_symbol)
    new_list = [Enum.at(new_string, str_len - 3), Enum.at(new_string, str_len - 2), Enum.at(new_string, str_len - 1)]

    case String.to_charlist(currency) == new_list do
      true -> [current_symbol | accum]
      _ -> accum
    end
  end


  defp convert_to_list_of_maps(map) do
    current_time = Time.utc_now()
    symbol = map["symbol"]
    %{symbol => [%{price: map["price"], time: current_time}]}
  end

  defp update_db_data(current_db_data, current_configured_list) do
    ## get list of keys
    ## iterate through list of keys
    data = current_db_data |> List.first()
    new_db_data =
      Enum.map(data.current_price_data, fn {symbol, value} ->
        %{symbol => value ++ current_configured_list[symbol]}
      end)
      |> Enum.reduce(fn x, y ->
        Map.merge(x, y, fn _k, v1, v2 -> v2 ++ v1 end)
      end)

    CryptoApi.Exhchanges.update_binance(data, %{current_price_data: new_db_data})

  end


  # def handle_cast({:push, current_data}, state) do

  #   case Map.get(state, :current_price) do
  #     nil ->
  #       {:noreply, Map.put(state, :current_price, [current_data])}

  #     current_state ->
  #       single_list = current_state ++ [current_data]

  #       {:noreply, Map.put(state, :current_price, single_list)}
  #   end
  # end

  # end

  # def handle_call(:get, _from, state) do
  #   {:reply, state, state}
  # end

  defp schedule_coin_fetch() do
    Process.send_after(self(), :coin_fetch, 5000)
  end
end


# below is the old working code from current app-refactor branch
# def start_link(_args) do
#   GenServer.start_link(__MODULE__, %{coin: "BTCUSD"}, name: __MODULE__)
# end

# def init(state) do
#   schedule_coin_fetch()

#   {:ok, state}
# end

# def handle_info(:coin_fetch, %{coin: symbol} = state) do

#   current_data =
#     @binance_service.get_single_live_ticker_price(symbol) |> Map.put("time", Time.utc_now())

#   schedule_coin_fetch()
#   handle_cast({:push, current_data}, state)
# end

# def handle_cast({:push, current_data}, state) do

#   case Map.get(state, :current_price) do
#     nil ->
#       {:noreply, Map.put(state, :current_price, [current_data])}

#     current_state ->
#       single_list = current_state ++ [current_data]

#       {:noreply, Map.put(state, :current_price, single_list)}
#   end
# end

# def handle_call(:get, _from, state) do
#   {:reply, state, state}
# end

# defp schedule_coin_fetch() do
#   Process.send_after(self(), :coin_fetch, 5000)
# end

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
