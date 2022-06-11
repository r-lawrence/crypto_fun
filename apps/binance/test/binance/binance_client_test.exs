defmodule Binance.ClientTest do
  use ExUnit.Case
  import Mox

  alias Binance.Client

  @initial_symbols %{
    "BTC" => ["ETHBTC"],
    "USD" => ["BTCUSD"],
    "USDT" => ["FILUSDT"]
  }
  setup :verify_on_exit!

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(CryptoEngine.Repo)
    stub_with(Binance.APIMock, Binance.APIStub)
    :ok

  end

  describe "start_link/1" do
    test "starts the binance genserver pricing status of not_loaded" do
      assert {:ok, _pid} = start_supervised(Client)
    end

    test "trying to start the genserver when one exists, results in already started error" do
      assert {:ok, _pid} = Binance.Client.start_link(%{})
      assert {:error, _error} = Binance.Client.start_link(%{})
    end
  end

  describe "init/1" do
    test "schedules coin_fetch to be sent every five seconds and returns state" do
      state = %{pricing: :not_loaded}

      assert {:ok, state} ==  Binance.Client.init(state)
      assert_receive :coin_fetch, 6000
    end
  end

  describe "handle_info/2" do
    test "when database is empty: given a coin fetch atom and current state, should request new pricing data from api, format/save symbols/pricing data, and return noreply tuple with updated atom" do
      assert [] == CryptoEngine.Exchanges.list_binance_pricing()

      assert {:noreply, %{pricing: :updated}} ==
        Binance.Client.handle_info(:coin_fetch, %{pricing: :not_loaded})

      assert [%CryptoEngine.Exchanges.Binance{}] = CryptoEngine.Exchanges.list_binance_pricing()
    end


    test "when database is populated: given a coin fetch atom and current state, should request new pricing data from api, format/combine/update database, and return no reply tuple with updated atom" do
      initial_pricing_data = %{
        "BTCUSD" => [%{"price" => "29086.4700", "time" => "23:31:33.413756"}],
        "ETHBTC" => [%{"price" => "0.06770700", "time" => "23:31:33.413759"}],
        "FILUSDT" => [%{"price" => "1974.75000000", "time" => "23:31:33.413760"}]
      }
      {:ok, %CryptoEngine.Exchanges.Binance{current_price_data: initial_pricing_data}} = initial_pricing(initial_pricing_data, @initial_symbols)

      assert length(Map.get(initial_pricing_data, "BTCUSD")) == 1
      assert length(Map.get(initial_pricing_data, "ETHBTC")) == 1
      assert length(Map.get(initial_pricing_data, "FILUSDT")) == 1
      assert {:noreply, %{pricing: :updated}} ==
        Binance.Client.handle_info(:coin_fetch, %{pricing: :updated})

      [%CryptoEngine.Exchanges.Binance{current_price_data: updated_pricing_data}] = CryptoEngine.Exchanges.list_binance_pricing()

      assert length(Map.get(updated_pricing_data, "BTCUSD")) == 2
      assert length(Map.get(updated_pricing_data, "ETHBTC")) == 2
      assert length(Map.get(updated_pricing_data, "FILUSDT")) == 2
    end

    test "after successful handle_info, symbols should be formatted correctly and newest pricing data should be added to end of corresponding list" do
      initial_pricing_data = %{
        "BTCUSD" => [%{"price" => "29086.4700", "time" => "23:31:33.413756"}],
        "ETHBTC" => [%{"price" => "0.06770700", "time" => "23:31:33.413759"}],
        "FILUSDT" => [%{"price" => "1974.75000000", "time" => "23:31:33.413760"}]
      }
      {:ok, %CryptoEngine.Exchanges.Binance{current_price_data: initial_pricing_data}} = initial_pricing(initial_pricing_data, @initial_symbols)

      assert {:noreply, %{pricing: :updated}} ==
        Binance.Client.handle_info(:coin_fetch, %{pricing: :updated})

      [%CryptoEngine.Exchanges.Binance{current_price_data: updated_pricing_data, current_symbols: current_symbols}] = CryptoEngine.Exchanges.list_binance_pricing()

      new_btcusd = Map.get(updated_pricing_data, "BTCUSD")
      new_ethbtc = Map.get(updated_pricing_data, "ETHBTC")
      new_filusdt = Map.get(updated_pricing_data, "FILUSDT")

      assert @initial_symbols == current_symbols
      assert [List.first(Map.get(initial_pricing_data, "BTCUSD")), List.last(new_btcusd)] == new_btcusd
      assert [List.first(Map.get(initial_pricing_data, "ETHBTC")), List.last(new_ethbtc)] == new_ethbtc
      assert [List.first(Map.get(initial_pricing_data, "FILUSDT")), List.last(new_filusdt)] == new_filusdt
    end

    test "handle info, should schedule the next coin fetch in about 5 seconds" do
      assert {:noreply, %{pricing: :updated}} ==
        Binance.Client.handle_info(:coin_fetch, %{pricing: :not_loaded})

      assert_receive :coin_fetch, 6000
    end
  end

  describe "handle_call/3" do
    test "given a get atom, from tuple, and current state, should return a reply tuple containing state" do
      initial_pricing_data = %{
        "BTCUSD" => [%{"price" => "29086.4700", "time" => "23:31:33.413756"}],
        "ETHBTC" => [%{"price" => "0.06770700", "time" => "23:31:33.413759"}],
        "FILUSDT" => [%{"price" => "1974.75000000", "time" => "23:31:33.413760"}]
      }
      {:ok, %CryptoEngine.Exchanges.Binance{}} = initial_pricing(initial_pricing_data, @initial_symbols)
      {:ok, pid} = start_supervised(Client)

      from_tuple = {pid, :get}

      assert {:reply, %{pricing: :updated}, %{pricing: :updated}} ==
        Binance.Client.handle_call(:get, from_tuple, %{pricing: :updated})
    end

  end

  defp initial_pricing(new_pricing, symbols) do
    attrs = %{current_price_data: new_pricing, date: Date.utc_today(), current_symbols: symbols}
    CryptoEngine.Exchanges.create_binance(attrs)
  end
end
