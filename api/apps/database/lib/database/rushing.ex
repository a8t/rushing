defmodule Database.Rushing do
  @moduledoc """
  The Rushing context.
  """

  import Ecto.Query, warn: false
  alias Database.Repo

  alias Database.Rushing.RushingStatistic

  @doc """
  Returns the list of rushing_statistics.

  ## Examples

      iex> list_rushing_statistics()
      [%RushingStatistic{}, ...]

  """
  def list_rushing_statistics do
    Repo.all(RushingStatistic)
  end

  def list_rushing_statistics(:paged, page: page, page_size: page_size) do
    RushingStatistic
    |> Repo.paginate(%{page: page, page_size: page_size})
  end

  @doc """
  Gets a single rushing_statistic.

  Raises if the Rushing statistic does not exist.

  ## Examples

      iex> get_rushing_statistic!(123)
      %RushingStatistic{}

  """
  def get_rushing_statistic!(id), do: raise("TODO")

  @doc """
  Creates a rushing_statistic.

  ## Examples

      iex> create_rushing_statistic(%{field: value})
      {:ok, %RushingStatistic{}}

      iex> create_rushing_statistic(%{field: bad_value})
      {:error, ...}

  """
  def create_rushing_statistic(attrs \\ %{}) do
    IO.inspect(attrs)

    struct(%RushingStatistic{}, attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rushing_statistic.

  ## Examples

      iex> update_rushing_statistic(rushing_statistic, %{field: new_value})
      {:ok, %RushingStatistic{}}

      iex> update_rushing_statistic(rushing_statistic, %{field: bad_value})
      {:error, ...}

  """
  def update_rushing_statistic(%RushingStatistic{} = rushing_statistic, attrs) do
    raise "TODO"
  end

  @doc """
  Deletes a RushingStatistic.

  ## Examples

      iex> delete_rushing_statistic(rushing_statistic)
      {:ok, %RushingStatistic{}}

      iex> delete_rushing_statistic(rushing_statistic)
      {:error, ...}

  """
  def delete_rushing_statistic(%RushingStatistic{} = rushing_statistic) do
    raise "TODO"
  end

  @doc """
  Returns a data structure for tracking rushing_statistic changes.

  ## Examples

      iex> change_rushing_statistic(rushing_statistic)
      %Todo{...}

  """
  def change_rushing_statistic(%RushingStatistic{} = rushing_statistic, _attrs \\ %{}) do
    raise "TODO"
  end
end
