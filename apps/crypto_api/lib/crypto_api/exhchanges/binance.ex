defmodule CryptoApi.Exhchanges.Binance do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "binance_pricing" do
    field :current_price_data, :map
    field :date, :date
    field :current_symbols, :map

    timestamps()
  end

  @doc false
  def changeset(binance, attrs) do
    binance
    |> cast(attrs, [:current_price_data, :date, :current_symbols])
    |> validate_required([:current_price_data, :date, :current_symbols])
  end
end
