defmodule Binance.ClientTest do
  use ExUnit.Case, async: true
  import Mox

  alias Binance.Client

  setup :verify_on_exit!

  describe "start_link/1" do
    test "starts the binance genserver" do
      assert {:ok, _pid} = start_supervised(Client)
    end

    test "trying to start the genserver when one exists, results in already started error" do
      start_supervised(Client)

      assert {:error, _error} = start_supervised(Client)
    end
  end

  describe "init/1" do
    test "returns an ok tuple containing state" do
      assert {:ok, %{}} == Binance.Client.init(%{})
    end

    test "schedules coin_fetch to be sent every 5 seconds" do
      assert {:ok, %{}} == Binance.Client.init(%{})
      assert_receive :coin_fetch, 6000
    end
  end

  describe "handle_info/2" do
    test "given a coin_fetch atom and a valid map, should return the coins value" do
      Binance.APIMock
      |> expect(:get_single_live_ticker_price, 3, fn coin_data ->
        %{"price" => 35250, "symbol" => coin_data}
      end)

      assert {:noreply,
              %{
                coin: "ETHUSD",
                current_price: [
                  %{"price" => 35250, "symbol" => "ETHUSD"}
                ]
              }} = Binance.Client.handle_info(:coin_fetch, %{coin: "ETHUSD"})

      assert {:noreply,
              %{
                coin: "BTCUSD",
                current_price: [
                  %{"price" => 35250, "symbol" => "BTCUSD"}
                ]
              }} = Binance.Client.handle_info(:coin_fetch, %{coin: "BTCUSD"})

      assert {:noreply,
              %{
                coin: "RVNUSD",
                current_price: [
                  %{"price" => 35250, "symbol" => "RVNUSD"}
                ]
              }} = Binance.Client.handle_info(:coin_fetch, %{coin: "RVNUSD"})
    end

    test "should schedule coin_fetch to be sent every five seconds, for the specific coin" do
      Binance.APIMock
      |> expect(:get_single_live_ticker_price, 1, fn _coin_data ->
        %{"price" => 35250, "symbol" => "ETHUSD"}
      end)

      start_supervised(Client)
      Client.handle_info(:coin_fetch, %{coin: "ETHUSD"})

      assert_receive :coin_fetch, 6000
    end
  end

  describe "handle_cast/2" do
    test "given a update/new data as request and an empty state, should return new state" do
      empty_state = %{}
      coin_data = %{"price" => 35250, "symbol" => "BTCUSD", "time" => Time.utc_now()}

      assert {:noreply, %{current_price: [%{"price" => 35250, "symbol" => "BTCUSD"}]}} =
               Client.handle_cast({:push, coin_data}, empty_state)
    end

    test "given a update request and current state, should return new state at end of current_price list" do
      coin_data = %{"price" => 33000, "symbol" => "BTCUSD", "time" => ~T[23:00:08.000]}

      current_state = %{
        current_price: [%{"price" => 35250, "symbol" => "BTCUSD", "time" => ~T[23:00:07.001]}]
      }

      final_data = current_state.current_price ++ [coin_data]

      assert {:noreply, %{current_price: final_data}} ==
               Client.handle_cast({:push, coin_data}, current_state)
    end
  end

  describe "handle_call/2" do
    test "give a :get atom, a request, current coin price state, should return a reply" do
      {:ok, pid} = start_supervised(Client)
      coin_data = %{"price" => 33000, "symbol" => "BTCUSD", "time" => ~T[23:00:08.000]}

      state = %{
        current_price: [%{"price" => 35250, "symbol" => "BTCUSD", "time" => ~T[23:00:07.001]}]
      }

      {:noreply, %{current_price: current_price_state}} =
        Client.handle_cast({:push, coin_data}, state)

      {:reply, reply_state, genserver_state} =
        Client.handle_call(:get, {pid, :current_price}, current_price_state)

      assert reply_state == current_price_state
      assert genserver_state == current_price_state
    end
  end
end
