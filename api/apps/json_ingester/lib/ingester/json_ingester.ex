defmodule Rushing.JsonIngester do
  alias Database.RushingStatistic, as: RushingStatistic
  alias Database.Repo

  def ingest_json(arg) do
    File.read!(arg)
    |> Jason.decode!()
    |> sanitize()
    |> insert_statistics()
  end

  defp sanitize(rows) do
    rows
    |> Enum.map(fn row ->
      %{
        player_name: row["Player"],
        player_team: row["Team"],
        player_position: row["Pos"],
        attempts: parse_to_float(row["Att"]),
        attempts_per_game_average: parse_to_float(row["Att/G"]),
        yards_per_game: parse_to_float(row["Yds"]),
        total_yards: parse_to_float(row["Avg"]),
        yards_per_attempt_average: parse_to_float(row["Yds/G"]),
        total_rushing_touchdowns: parse_to_float(row["TD"]),
        longest_rush: parse_longest_rush(row["Lng"]),
        first_downs: parse_to_float(row["1st"]),
        first_down_percentage: parse_to_float(row["1st%"]),
        over_twenty_yards: parse_to_float(row["20+"]),
        over_forty_yards: parse_to_float(row["40+"]),
        fumbles: parse_to_float(row["FUM"])
      }
    end)
  end

  defp insert_statistics(statistics) do
    Repo.insert_all(RushingStatistic, statistics)
  end

  defp parse_to_float(val) when is_binary(val),
    do: val |> String.replace(",", "") |> Float.parse() |> elem(0)

  defp parse_to_float(val) when is_integer(val), do: val / 1
  defp parse_to_float(val) when is_float(val), do: val

  defp parse_longest_rush(lng) when is_integer(lng), do: Integer.to_string(lng)
  defp parse_longest_rush(lng) when is_float(lng), do: Float.to_string(lng)
  defp parse_longest_rush(lng) when is_binary(lng), do: lng
end
