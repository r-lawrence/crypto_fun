defmodule CryptoEngine.ExhchangesTest do
  use CryptoEngine.DataCase

  # alias CryptoEngine.Exhchanges

  # describe "binance_pricing" do
  #   alias CryptoEngine.Exhchanges.Binance

    # import CryptoEngine.ExhchangesFixtures

    # @invalid_attrs %{coin_symbol: nil, current_price_data: nil, date: nil, id: nil}

    # test "list_binance_pricing/0 returns all binance_pricing" do
    #   binance = binance_fixture()
    #   assert Exhchanges.list_binance_pricing() == [binance]
    # end

    # test "get_binance!/1 returns the binance with given id" do
    #   binance = binance_fixture()
    #   assert Exhchanges.get_binance!(binance.id) == binance
    # end

    # test "create_binance/1 with valid data creates a binance" do
    #   valid_attrs = %{coin_symbol: "some coin_symbol", current_price_data: [], date: ~D[2022-05-14], id: "7488a646-e31f-11e4-aace-600308960662"}

    #   assert {:ok, %Binance{} = binance} = Exhchanges.create_binance(valid_attrs)
    #   assert binance.coin_symbol == "some coin_symbol"
    #   assert binance.current_price_data == []
    #   assert binance.date == ~D[2022-05-14]
    #   assert binance.id == "7488a646-e31f-11e4-aace-600308960662"
    # end

    # test "create_binance/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = Exhchanges.create_binance(@invalid_attrs)
    # end

    # test "update_binance/2 with valid data updates the binance" do
    #   binance = binance_fixture()
    #   update_attrs = %{coin_symbol: "some updated coin_symbol", current_price_data: [], date: ~D[2022-05-15], id: "7488a646-e31f-11e4-aace-600308960668"}

    #   assert {:ok, %Binance{} = binance} = Exhchanges.update_binance(binance, update_attrs)
    #   assert binance.coin_symbol == "some updated coin_symbol"
    #   assert binance.current_price_data == []
    #   assert binance.date == ~D[2022-05-15]
    #   assert binance.id == "7488a646-e31f-11e4-aace-600308960668"
    # end

    # test "update_binance/2 with invalid data returns error changeset" do
    #   binance = binance_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Exhchanges.update_binance(binance, @invalid_attrs)
    #   assert binance == Exhchanges.get_binance!(binance.id)
    # end

    # test "delete_binance/1 deletes the binance" do
    #   binance = binance_fixture()
    #   assert {:ok, %Binance{}} = Exhchanges.delete_binance(binance)
    #   assert_raise Ecto.NoResultsError, fn -> Exhchanges.get_binance!(binance.id) end
    # end

    # test "change_binance/1 returns a binance changeset" do
    #   binance = binance_fixture()
    #   assert %Ecto.Changeset{} = Exhchanges.change_binance(binance)
    # end
  # end
end
