defmodule CryptoEngine.ExchangesTest do
  use CryptoEngine.DataCase

  alias CryptoEngine.Exchanges

  import CryptoEngine.ExhchangesFixtures

  describe "list_binance_pricing/0" do
    test "returns an empty list when binance does not exist" do
      assert [] == Exchanges.list_binance_pricing()
    end

    test "when binance is populated, should return a list containing a single binance struct" do
      binance = binance_fixture()
      assert [binance] = Exchanges.list_binance_pricing()
    end
  end

  describe "create_binance/1" do
    test "given valid attributes, creates and returns an ok tuple with new binance struct" do
       attrs = %{
         current_price_data: %{"BTCUSD" => [%{"price" => "30,250", "time" => Time.utc_now()}]},
         date: Date.utc_today(),
         current_symbols: %{"USD" => ["BTCUSD"]}
       }
       assert {:ok, %CryptoEngine.Exchanges.Binance{}} = Exchanges.create_binance(attrs)
    end

    test "when date is not provided, returns an ecto changeset error" do
      attrs = %{
        current_price_data: %{"BTCUSD" => [%{"price" => "30,250", "time" => Time.utc_now()}]},
        current_symbols: %{"USD" => ["BTCUSD"]}
      }

      assert {:error, %Ecto.Changeset{}} = Exchanges.create_binance(attrs)
    end

    test "when current price data is not provided, returns an ecto changeset error" do
      attrs = %{
        date: Date.utc_today(),
        current_symbols: %{"USD" => ["BTCUSD"]}
      }

      assert {:error, %Ecto.Changeset{}} = Exchanges.create_binance(attrs)
    end

    test "when current symbols are not provided, returns an ecto changeset error" do
      attrs = %{
        current_price_data: %{"BTCUSD" => [%{"price" => "30,250", "time" => Time.utc_now()}]},
        date: Date.utc_today()
      }

      assert {:error, %Ecto.Changeset{}} = Exchanges.create_binance(attrs)
    end

    test "given an attributes map containing valid and non exisiting attributes, returns an ok tuple containing a binance with only valid attributes" do
      attrs = %{
        current_price_data: %{"BTCUSD" => [%{"price" => "30,250", "time" => Time.utc_now()}]},
        date: Date.utc_today(),
        current_symbols: %{"USD" => ["BTCUSD"]},
        faker: "this is fake attribute"
      }

      assert {:ok, %CryptoEngine.Exchanges.Binance{} = binance} = Exchanges.create_binance(attrs)
      assert nil == Map.get(binance, :faker)
    end
  end

  describe "update_binance/2" do
    test "given a current binance and new attributes, returns ok tuple containing updated binance" do
      binance = binance_fixture()
      attrs = %{
        current_price_data: %{"BTCUSD" => [%{"price" => "30,250", "time" => Time.utc_now()}]},
        date: Date.utc_today(),
        current_symbols: %{"USD" => ["BTCUSD"]},
      }
      updated_symbols = attrs[:current_symbols]
      updated_pricing = attrs[:current_price_data]
      updated_date = attrs[:date]

       assert {
         :ok,
         %CryptoEngine.Exchanges.Binance{
           current_symbols: ^updated_symbols,
           date: ^updated_date,
           current_price_data: ^updated_pricing
          }
        } =
        Exchanges.update_binance(binance, attrs)
    end

    test "when given an attribute that does not exist, does not update binance and returns an ok tuple with original binance" do
      binance = binance_fixture()
      attr = %{
        faker: "does not exist"
      }

      assert {:ok, binance} = Exchanges.update_binance(binance, attr)
      assert Map.get(binance, :faker) == nil
    end
  end

  describe "delete_binance/2" do
    test "given an existing binance, deletes the record from database and returns ok tuple with the deleted binance" do
      binance = binance_fixture()

      assert {:ok, %CryptoEngine.Exchanges.Binance{}} = Exchanges.delete_binance(binance)
      assert [] == Exchanges.list_binance_pricing()
    end

    test "given a binance that does not exist, raises an error" do
      binance = %CryptoEngine.Exchanges.Binance{}

      assert_raise Ecto.NoPrimaryKeyValueError, fn ->
        Exchanges.delete_binance(binance)
      end
    end
  end
end
