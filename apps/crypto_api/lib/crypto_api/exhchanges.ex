defmodule CryptoApi.Exhchanges do
  @moduledoc """
  The Exhchanges context.
  """

  import Ecto.Query, warn: false
  alias CryptoApi.Repo

  alias CryptoApi.Exhchanges.Binance

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
  Gets a single binance.

  Raises `Ecto.NoResultsError` if the Binance does not exist.

  ## Examples

      iex> get_binance!(123)
      %Binance{}

      iex> get_binance!(456)
      ** (Ecto.NoResultsError)

  """
  def get_binance!(id), do: Repo.get!(Binance, id)

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

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking binance changes.

  ## Examples

      iex> change_binance(binance)
      %Ecto.Changeset{data: %Binance{}}

  """
  def change_binance(%Binance{} = binance, attrs \\ %{}) do
    Binance.changeset(binance, attrs)
  end
end
