defmodule RushingWeb.RushingStatisticController.Helper do
  @spec get_sort_kwlist(binary) :: [{atom(), atom()}]
  def get_sort_kwlist(""), do: []

  def get_sort_kwlist(sort_query_string) do
    sort_query_string
    |> String.split(",")
    |> Enum.map(&to_atomized_tuple(&1))
    |> Enum.reject(&(&1 == :error))
  end

  defp to_atomized_tuple(string) do
    [sort_key, direction] =
      string
      |> String.split(" ")

    with {:ok, atomized_sort_key} <- safe_string_to_atom(sort_key),
         {:ok, atomized_direction} <- safe_string_to_atom(direction) do
      {atomized_direction, atomized_sort_key}
    end
  end

  defp safe_string_to_atom(str) do
    _valid_sort_keys = [:total_yards, :total_rushing_touchdowns, :longest_rush]
    _valid_directions = [:asc, :desc]

    try do
      {:ok, String.to_existing_atom(str)}
    rescue
      ArgumentError -> :error
    end
  end
end
