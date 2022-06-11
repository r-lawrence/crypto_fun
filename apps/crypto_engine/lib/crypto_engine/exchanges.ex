defmodule CryptoEngine.Exchanges do
  @moduledoc """
  The Exhchanges context.
  """

  import Ecto.Query, warn: false
  alias CryptoEngine.Repo

  alias CryptoEngine.Exchanges.Binance

  @doc """
  Returns the list of binance_pricing.

  ## Examples

      iex> list_binance_pricing()
      [%Binance{}, ...]

  """
  def list_binance_pricing do
    Repo.all(Binance)
  end

  @doc """
  Creates a binance.

  ## Examples

      iex> create_binance(%{field: value})
      {:ok, %Binance{}}

      iex> create_binance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_binance(attrs \\ %{}) do
    %Binance{}
    |> Binance.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a binance.

  ## Examples

      iex> update_binance(binance, %{field: new_value})
      {:ok, %Binance{}}

      iex> update_binance(binance, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_binance(%Binance{} = binance, attrs) do
    binance
    |> Binance.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a binance.

  ## Examples

      iex> delete_binance(binance)
      {:ok, %Binance{}}

      iex> delete_binance(binance)
      {:error, %Ecto.Changeset{}}

  """
  def delete_binance(%Binance{} = binance) do
    Repo.delete(binance)
  end
end
