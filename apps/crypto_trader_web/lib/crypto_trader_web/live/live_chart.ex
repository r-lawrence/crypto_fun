defmodule CryptoTraderWeb.LiveChart do
  use Phoenix.LiveView

  def mount(params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 5_000)
    handle_params(params, socket)
  end

  def handle_params(%{current_coin: coin_symbol} = _params, socket) do
    {:ok, assign(socket, :current_symbol, coin_symbol)}
  end

  def handle_params(%{} = _params, socket) do
    ## handle default BTC chart data on entry
    case CryptoApi.Exhchanges.list_binance_pricing() |> List.first() do
      nil ->
        {:ok, socket}
     %CryptoApi.Exhchanges.Binance{current_symbols: symbols, current_price_data: %{"BTCUSD" => price_data}} ->

      chart_data = %{labels: create_time_list(price_data), data: create_price_list(price_data), selectedSymbol: "BTCUSD"}

        socket =
          socket
          |> assign(:current_symbol, "BTCUSD")
          |> assign(:coins, symbols)

      {:ok, push_event(socket, "element-updated", chart_data)}
    end
  end

  def handle_info(:update, %{assigns: %{current_symbol: current_symbol}} = socket) do
    Process.send_after(self(), :update, 5_000)
    %{pricing: status} =
      GenServer.call(Binance.Client, :get)

      if status == :updated do
        current_data = CryptoApi.Exhchanges.list_binance_pricing() |> List.first()
        data = current_data.current_price_data[current_symbol]
        chart_data = %{labels: create_time_list(data), data: create_price_list(data), selectedSymbol: current_symbol}
        {:noreply, push_event(socket, "element-updated", chart_data)}
      else
        {:noreply, socket}
      end
  end

  def handle_event("inc_coin_change", %{"value" => symbol}, socket) do
    {:noreply, assign(socket, :current_symbol, symbol)}
  end



  def render(assigns) do
    coins = Map.get(assigns, :coins)
    case coins do
      nil ->
      assigns = assigns |> Map.put(:coins, %{})
      Phoenix.View.render(CryptoTraderWeb.PageView, "live_chart.html", assigns)
      _ ->
        Phoenix.View.render(CryptoTraderWeb.PageView, "live_chart.html", assigns)
    end
  end

  defp create_price_list(data) do
    case data do
      nil ->
        nil

      list ->
        list
        |> Enum.map(fn current_map -> Map.get(current_map, "price") end)
    end
  end

  defp create_time_list(data) do
    case data do
      nil ->
        nil

      list ->
        list
        |> Enum.map(fn current_map -> Map.get(current_map, "time") end)
    end
  end
end
