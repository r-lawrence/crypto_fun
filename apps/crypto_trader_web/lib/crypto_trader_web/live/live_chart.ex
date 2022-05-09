defmodule CryptoTraderWeb.LiveChart do
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(CryptoTraderWeb.PageView, "live_chart.html", assigns)
  end

  def mount(_params, _, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 5_000)

    {:ok, socket}
  end

  def handle_event("inc_coin_change", %{"value" => symbol}, socket) do
    current_pid = Map.get(socket, :current_pid)
    current_symbol = Map.get(socket, :current_symbol)

    if symbol != current_symbol do
      GenServer.stop(current_pid, :normal)
      handle_params(%{current_coin: symbol}, "/live-chart", socket)
    else
      {:noreply, socket}
    end
  end

  def handle_params(params, _uri, socket) do
    handle_coin_link(params, socket)
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 5_000)
    current_pid = Map.get(socket, :current_pid)
    chart_data = get_and_format_chart_data(current_pid)

    {:noreply, push_event(socket, "element-updated", chart_data)}
  end

  defp handle_coin_link(params, socket) do
    case params do
      %{current_coin: coin_symbol} ->
        socket = Map.put(socket, :current_symbol, coin_symbol)
        start_link(%{coin: coin_symbol}, socket)

      %{} ->
        socket = Map.put(socket, :current_symbol, "BTCUSD")
        start_link(%{coin: "BTCUSD"}, socket)
    end
  end

  defp start_link(params, socket) do
    case Binance.Client.start_link(params) do
      {:ok, pid} ->
        create_reply(socket, pid)

      {:error, {:already_started, pid}} ->
        create_reply(socket, pid)
    end
  end

  defp create_reply(socket, pid) do
    socket = socket |> Map.put(:current_pid, pid)
    {:noreply, assign(socket, :data, Jason.encode!(%{}))}
  end

  defp get_and_format_chart_data(pid) do
    data =
      GenServer.call(pid, :get)
      |> Map.get(:current_price)

    price_list = create_price_list(data)
    time_list = create_time_list(data)

    %{labels: time_list, data: price_list}
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
