defmodule CryptoWeb.LiveChart do
  use Phoenix.LiveView

  @behaviour CryptoWeb.LiveChartBehaviour

  defp adapter do
    Application.get_env(:crypto_web, CryptoWeb.LiveChart)[:genserver_adapter]
  end

  def mount(params, _session, socket) do
    if connected?(socket) do
      Process.send_after(socket.root_pid, :update, 5_000)
    end

    handle_params(params, socket)
  end

  def handle_params(%{} = _params, socket) do
    case adapter().get_client_status() do
      %{pricing: :updated} ->
        [%CryptoEngine.Exchanges.Binance{current_symbols: symbols, current_price_data: %{"BTCUSD" => price_data}}] =
          CryptoEngine.Exchanges.list_binance_pricing()
        chart_data = %{labels: create_time_list(price_data), data: create_price_list(price_data), selectedSymbol: "BTCUSD"}

        socket =
          socket
          |> assign(:current_symbol, "BTCUSD")
          |> assign(:coins, symbols)

        {:ok, push_event(socket, "element-updated", chart_data)}

      _ ->
        {:ok, socket}
    end
  end


  def handle_info(:update, %{assigns: %{current_symbol: current_symbol}} = socket) do
    Process.send_after(socket.root_pid, :update, 5_000)
    case adapter().get_client_status() do
      %{pricing: :updated} ->

        current_data = CryptoEngine.Exchanges.list_binance_pricing() |> List.first()
        data = current_data.current_price_data[current_symbol]
        chart_data = %{labels: create_time_list(data), data: create_price_list(data), selectedSymbol: current_symbol}

        {:noreply, push_event(socket, "element-updated", chart_data)}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_info(:update, socket) do
    {:noreply, socket}
  end

  def handle_event("inc_coin_change", %{"value" => symbol}, socket) do
    {:noreply, assign(socket, :current_symbol, symbol)}
  end

  def render(assigns) do
    coins = Map.get(assigns, :coins)

    case coins do
      nil ->
        assigns =
          assigns
          |> Map.put(:coins, %{})
        Phoenix.View.render(CryptoWeb.PageView, "live_chart.html", assigns)
      _ ->
        Phoenix.View.render(CryptoWeb.PageView, "live_chart.html", assigns)
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


  @spec get_client_status() :: map()
  def get_client_status() do
    GenServer.call(Binance.Client, :get)
  end
end
