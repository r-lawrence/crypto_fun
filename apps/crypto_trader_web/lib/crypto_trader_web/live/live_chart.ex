defmodule CryptoTraderWeb.LiveChart do
  use Phoenix.LiveView




  @spec mount(any, any, Phoenix.LiveView.Socket.t()) :: {:ok, Phoenix.LiveView.Socket.t()}
  def mount(_params, _session, socket) do


    if connected?(socket), do: Process.send_after(self(), :update, 5_000)
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    handle_coin_link(params, socket)
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 5_000)
    current_pid = Map.get(socket, :current_pid)

    current_symbol = Map.get(socket, :current_symbol)



    chart_data = get_and_format_chart_data(current_pid, current_symbol)


    {:noreply, push_event(socket, "element-updated", chart_data)}
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

  def render(assigns) do
    Phoenix.View.render(CryptoTraderWeb.PageView, "live_chart.html", assigns)
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

  defp start_link(_params, socket) do
  #  {:ok, pid} =  Binance.Client.start_link()


    case Binance.Client.start_link() do
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

  defp get_and_format_chart_data(pid, current_symbol) do


  %{pricing: status} =
    GenServer.call(pid, :get) |> IO.inspect()

    case status do
      :not_loaded->
        %{labels: "waiting", data: "waiting"}
      :updated ->
        current_data = CryptoApi.Exhchanges.list_binance_pricing() |> List.first()
        data = current_data.current_price_data[current_symbol]
        %{labels: create_time_list(data), data: create_price_list(data)}
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
