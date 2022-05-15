defmodule CryptoTraderWeb.LiveChartTest do
  use ExUnit.Case, async: true

  import Plug.Conn
  import Phoenix.ConnTest
  import Phoenix.LiveViewTest

  # alias CryptoTraderWeb.Router.Helpers, as: Routes

  alias CryptoTraderWeb.LiveChart
  @endpoint CryptoTraderWeb.Endpoint

  # @current_Valid_coins ["BTCUSD", "ETHUSD", "RVNUSD"]

  # setup do
  #   conn = build_conn()
  #   {:ok, %{conn: conn}}
  # end



  describe "mount/3" do

    setup do
      %{socket: socket} =
        %{socket: %Phoenix.LiveView.Socket{}}

      {:ok, %{socket: socket}}
    end
    test "given empty map as params, empty map as session, and a socket, should return an ok tuple containig the socket", %{socket: socket} do
      assert {:ok, %Phoenix.LiveView.Socket{}} =
        LiveChart.mount(%{}, %{}, socket)
    end

  end

  describe "handle_params/3" do

    setup do
      %{socket: socket} =
        %{socket: %Phoenix.LiveView.Socket{}}

      {:ok, socket} =
        LiveChart.mount(%{}, %{}, socket)

      {:ok, %{socket: socket}}
    end

    test "given an empty map as params, live_chart as uri, and a mounted socket, should return a socket containing the current_pid/current_symbol defaulting to BTCUSD",
      %{socket: socket}
    do
       {:noreply, socket} = LiveChart.handle_params(%{}, "www.example.com/live-chart", socket)

       assert Map.get(socket, :current_pid) != nil
       assert "BTCUSD" == Map.get(socket, :current_symbol)
    end

    test "given map containing a current coin of ETHUSD, live_chart as uri, and a mounted socket, should return a socket containing the current_pid/current_symbol of ETHUSD",
      %{socket: socket}
    do
      {:noreply, socket} = LiveChart.handle_params(%{current_coin: "ETHUSD"}, "www.example.com/live-chart", socket)

      assert Map.get(socket, :current_pid) != nil
      assert "ETHUSD" == Map.get(socket, :current_symbol)
    end
  end

  # describe "handle_info/2" do
    # test "..." do
    #   %{socket: socket} =
    #     %{socket: %Phoenix.LiveView.Socket{}}

    #   {:ok, socket} =
    #     LiveChart.mount(%{}, %{}, socket)

    #   {:noreply, socket} = LiveChart.handle_params(%{}, "www.example.com/live-chart", socket)


    #   # # Process.send(:coin_fetch, %{"symbol" => "BTCUSD"}, []) |> IO.inspect()
    #   payload = %{"price" => 25000, "symbol" => "BTCUSD", "time" => Time.utc_now()}
    #   GenServer.cast(Map.get(socket, :current_pid), {:push, payload})
    #   current_pid = Map.get(socket, :current_pid)
    #   GenServer.call(Map.get(socket, :current_pid), :get)

    #   # LiveChart.handle_info(:update, socket)


    #   conn = build_conn()

    #   {:ok, view, _html} = live(conn, "/live-chart")

    #   view = Map.replace(view, :pid, current_pid)
    #   # ele =
    #   #   view
    #   #   |> element("#live-chart")

    #   live_redirect(view, to: "/live-chart") |> IO.inspect()


      # LiveChart.handle_info(:update, socket)



      # assert_reply(view, payload, timeout \\ 100)

      # assert  {:noreply, push_event(socket, "element-updated", payload)} ==






      # assert_push_event view, "element-updated", payload, 100 |> IO.inspect()

    # end
    # test "another ..." do



    #   #  payload = %{"price" => 25000, "symbol" => "BTCUSD", "time" => Time.utc_now()}
    #   #  GenServer.cast(view.pid, {:push, payload}) |> IO.inspect()
    # end

  # end

  describe "render/1" do

    setup do
      %{socket: socket} =
        %{socket: %Phoenix.LiveView.Socket{}}

      {:ok, %{socket: socket}}
    end

    test "given a mounted socket with empty params, should render a live-chart template containing a div of main, buttons with coin-button class/inc_coin_change phx-click atrr, and live-chart canvas",
      %{socket: socket}
    do
      {:ok, %Phoenix.LiveView.Socket{assigns: assigns}} = LiveChart.mount(%{}, %{}, socket)

      %Phoenix.LiveView.Rendered{static: html} = LiveChart.render(assigns)
      html = Floki.parse_document!(html)

      main = Floki.find(html, "#main")
      buttons = Floki.find(html, "button.coin-button")
      live_chart = Floki.find(html, "canvas#live-chart")

      assert [] != main
      assert [] != buttons
      assert [] != live_chart

      Enum.each(buttons, fn button ->
        phx_click = Floki.attribute(button, "phx-click")
        assert phx_click == ["inc_coin_change"]
      end)
    end

  end





  # test "on mount, renders buttons for all availible crypto and renders live_chart element",
  #   %{conn: conn}
  # do

    # html =
    #   conn
    #   |> html_response(200)
    #   |> Floki.parse_document!()

    # button_values =
    #   html
    #   |> Floki.find("button.coin-button")
    #   |> Floki.attribute("value")
    #   |> Floki.text()

    # live_chart =
    #   html
    #   |> Floki.find("#live-chart")


    # Enum.find(@current_Valid_coins, fn valid_value ->
    #   assert not String.contains?(button_values, "fail")
    #   assert String.contains?(button_values, valid_value)
    # end)

    # assert not Enum.empty?(live_chart)
  # end



  # test ""


end
