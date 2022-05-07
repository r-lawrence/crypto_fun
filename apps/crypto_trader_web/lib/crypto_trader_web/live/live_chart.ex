defmodule CryptoTraderWeb.LiveChart do
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(CryptoTraderWeb.PageView, "live_chart.html", assigns)
  end

  def mount(_params, _, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 5_000)
    case Binance.Client.start_link(%{}) do
      {:ok, pid} ->
        socket = socket |> Map.put(:current_pid, pid)
        {:ok, assign(socket, :data, Jason.encode!(%{}))}

      {:error, {:already_started, pid}} ->
        socket = socket |> Map.put(:current_pid, pid)
        {:ok, assign(socket, :data, Jason.encode!(%{}))}

    end
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 5_000)

    current_pid = Map.get(socket, :current_pid)

    chart_data = get_and_format_chart_data(current_pid)


    {:noreply, push_event(socket, "element-updated", chart_data)}
  end
  def handle_event("inc_chart_change_btc", _, socket) do
     IO.inspect("hitting change for BTC")

     {:noreply, socket}
  end

  def handle_event("inc_chart_change_eth", _, socket) do
     IO.inspect("hitting change for eth")
     current_pid = Map.get(socket, :current_pid)
     GenServer.stop(current_pid, :normal)

     case Binance.Client.start_link(%{coin: "ETHUSD"}) do
      {:ok, pid} ->
        socket = socket |> Map.put(:current_pid, pid)
        {:noreply, assign(socket, :data, Jason.encode!(%{}))}

      {:error, {:already_started, pid}} ->
        socket = socket |> Map.put(:current_pid, pid)
        {:noreply, assign(socket, :data, Jason.encode!(%{}))}

    end
    #  {:noreply, socket}
  end

  def handle_event("inc_chart_change_rvn", _, socket) do
    IO.inspect("hitting change for rvn")
    current_pid = Map.get(socket, :current_pid)
    GenServer.stop(current_pid, :normal)

    case Binance.Client.start_link(%{coin: "RVNUSD"}) do
     {:ok, pid} ->
       socket = socket |> Map.put(:current_pid, pid)
       {:noreply, assign(socket, :data, Jason.encode!(%{}))}

     {:error, {:already_started, pid}} ->
       socket = socket |> Map.put(:current_pid, pid)
       {:noreply, assign(socket, :data, Jason.encode!(%{}))}

    end

  end
  # @spec handle_event(Phoenix.LiveView.Socket.t(), map) :: {:noreply, map}
  # def handle_event(socket, chart_data) do
  #   {:noreply, push_event(socket, "element-updated", chart_data)}
  # end

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
      nil -> nil
      list ->
        list
        |> Enum.map(fn current_map -> Map.get(current_map, "price") end)
    end
  end

  defp create_time_list(data) do
    case data do
      nil -> nil
      list ->
        list
        |> Enum.map(fn current_map -> Map.get(current_map, "time") end)
    end
  end

end
