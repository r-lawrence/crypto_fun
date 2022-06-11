defmodule CryptoWeb.LiveChartTest do
  use ExUnit.Case, async: true

  # import Plug.Conn
  import Phoenix.ConnTest
  # import Phoenix.LiveViewTest
  import Mox

  alias CryptoWeb.LiveChart
  @endpoint CryptoWeb.Endpoint
  setup :verify_on_exit!

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(CryptoEngine.Repo)
    fixture = CryptoEngine.ExhchangesFixtures.binance_fixture()
    :ok
    %{db_data: fixture}
  end

  describe "mount/3" do
    test "given empty params, session and socket: returns a ok tuple containing the socket" do
      stub(CryptoWeb.LiveChartMock, :get_client_status, fn ->
        %{pricing: :not_updated}
      end)

      %{socket: socket} =
        %{socket: %Phoenix.LiveView.Socket{}}

      assert {:ok, socket} == LiveChart.mount(%{}, %{}, socket)
    end
  end

  describe "handle_params/2" do
    test "empty params and socket: when binance client pricing status is not loaded, returns an ok tuple containing socket" do
      stub(CryptoWeb.LiveChartMock, :get_client_status, fn ->
        %{pricing: :not_updated}
      end)

      %{socket: socket} =
        %{socket: %Phoenix.LiveView.Socket{}}

      assert {:ok, socket} == LiveChart.handle_params(%{}, socket)
    end

    test "empty params and socket: when binance client pricing status is updated, assigns coins/currently symbol to socket and returns an ok tuple containing the socket",
      %{db_data: %CryptoEngine.Exchanges.Binance{current_symbols: coins}}
    do
      stub(CryptoWeb.LiveChartMock, :get_client_status, fn ->
        %{pricing: :updated}
      end)

      %{socket: socket} =
        %{socket: %Phoenix.LiveView.Socket{}}

      assert {:ok, %Phoenix.LiveView.Socket{assigns: %{coins: ^coins, current_symbol: "BTCUSD"}}} =
        LiveChart.handle_params(%{}, socket)
    end
  end

  describe "handle_info/2" do
    test "when binance pricing status is not_updated: given a update atom and assigns with a current symbol returns a noreply tuple containing the socket" do
      stub(CryptoWeb.LiveChartMock, :get_client_status, fn ->
        %{pricing: :not_updated}
      end)

      %{socket: socket} =
        %{socket: %Phoenix.LiveView.Socket{assigns: %{current_symbol: "ETHBTC"}}}

      assert {:noreply, socket} == LiveChart.handle_info(:update, socket)
    end

    test "when binance pricing status is updated: given :update atom and socket, returns a no reply tuple with socket containing element-updated event",
      %{db_data: %CryptoEngine.Exchanges.Binance{current_symbols: coins}}
    do
      stub(CryptoWeb.LiveChartMock, :get_client_status, fn ->
        %{pricing: :updated}
      end)

      %{socket: socket} =
        %{socket:
          %Phoenix.LiveView.Socket{
            assigns: %{
              __changed__: %{
                coins: true, current_symbol: true
              },
              current_symbol: "BTCUSD",
              coins: coins
            }
          }
        }

      assert %{__changed__: %{}} == socket.private
      assert {:noreply, socket} = LiveChart.handle_info(:update, socket)
      assert %{__changed__: %{push_events: [["element-updated" | _tail]]}} =
        socket.private
    end

    test "given just an update atom and socket, returns no reply tuple with socket" do
      %{socket: socket} =
        %{socket: %Phoenix.LiveView.Socket{}}

        assert {:noreply, socket} == LiveChart.handle_info(:update, socket)
    end
  end

  describe "handle_event/3" do
    test "given a inc_coin_change event, map contining a new coin value, and socket - assigns the current symbole to socket and return noreply tuple with socket" do
      %{socket: socket} =
        %{socket: %Phoenix.LiveView.Socket{}}

      assert {:noreply, socket} = LiveChart.handle_event("inc_coin_change", %{"value" => "ETHBTC"}, socket)

      %Phoenix.LiveView.Socket{assigns: assigns} = socket
      assert %{__changed__: %{current_symbol: true}, current_symbol: "ETHBTC"} ==
        assigns
    end

  end

  describe "render/1" do
    test "given an assigns map that doesnt contain coins, renders loading" do
      stub(CryptoWeb.LiveChartMock, :get_client_status, fn ->
        %{pricing: :not_updated}
      end)
      conn = build_conn()

      conn =
        conn
        |> Map.put(:assigns, %{})

        %Plug.Conn{resp_body: html_body} = get(conn, "/live-chart",%{})

        page_text =
          html_body
          |> Floki.parse_document!()
          |> Floki.text()

        assert page_text =~ "loading"
    end

    test "given an assigns map that contains coins, renders coin selection by currency" do
      stub(CryptoWeb.LiveChartMock, :get_client_status, fn ->
        %{pricing: :updated}
      end)
      conn = build_conn()
      %Plug.Conn{resp_body: html_body} = get(conn, "/live-chart",%{})


      coin_section_text =
        html_body
        |> Floki.parse_document!()
        |> Floki.text()


        assert coin_section_text =~ "USD"
        assert coin_section_text =~ "BTC"
        assert coin_section_text =~ "USDT"
    end
  end
end
