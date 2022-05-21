defmodule CryptoTraderWeb.LiveChart do
  use Phoenix.LiveView




  def mount(params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 5_000)
    # Binance.Application.start(%{}, %{}) |> IO.inspect()
    handle_coin_link(params, socket)
    # {:ok, socket}
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 5_000)
    current_pid = Map.get(socket, :current_pid)

    current_symbol = Map.get(socket, :current_symbol)

    %{pricing: status} =
      GenServer.call(current_pid, :get)

    case status do
      :not_loaded->
        chart_data = %{labels: "waiting", data: "waiting"}

        {:noreply, push_event(socket, "element-updated", chart_data)}
      :updated ->
        current_data = CryptoApi.Exhchanges.list_binance_pricing() |> List.first()

        coins = Map.get(socket.assigns, :coins)

        case coins do
          nil ->
            # Map.keys(current_data.current_price_data)

            current_symbols = current_data.current_symbols
            handle_info(:update_symbols, current_symbols, socket)
          _ ->
            # IO.inspect(current_data)
            data = current_data.current_price_data[current_symbol]
            chart_data = %{labels: create_time_list(data), data: create_price_list(data)}
            {:noreply, push_event(socket, "element-updated", chart_data)}
        end
    end
  end

  def handle_info(:update_symbols, symbols, socket) do

    {:noreply, assign(socket, :coins, symbols)}
  end

  def handle_event("inc_coin_change", %{"value" => symbol}, socket) do
    IO.inspect(symbol, label: "value change yoo")

    current_symbol = Map.get(socket, :current_symbol)
    if symbol != current_symbol do
      {:noreply, socket |> Map.replace!(:current_symbol, symbol)}
    else
      {:noreply, socket}
    end
  end

  # def handle_event("")

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

  defp handle_coin_link(params, socket) do
    case params do
      %{current_coin: coin_symbol} ->
        socket = Map.put(socket, :current_symbol, coin_symbol)
        start_link(socket)

      %{} ->
        socket = Map.put(socket, :current_symbol, "BTCUSD")
        start_link(socket)
    end
  end

  defp start_link(socket) do
    case Binance.Client.start_link() do
      {:ok, pid} ->
        create_reply(socket, pid)

      {:error, {:already_started, pid}} ->
        create_reply(socket, pid)
    end
  end

  defp create_reply(socket, pid) do
     socket = socket |> Map.put(:current_pid, pid)
    {:ok, socket}
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
