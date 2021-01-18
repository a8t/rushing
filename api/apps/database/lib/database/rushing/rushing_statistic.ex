defmodule Database.Rushing.RushingStatistic do
  use Ecto.Schema

  schema "rushing_statistics" do
    field(:player_name, :string)
    field(:player_team, :string)
    field(:player_position, :string)
    field(:attempts, :float)
    field(:attempts_per_game_average, :float)
    field(:total_yards, :float)
    field(:yards_per_attempt_average, :float)
    field(:yards_per_game, :float)
    field(:total_rushing_touchdowns, :float)
    field(:longest_rush, :string)
    field(:first_downs, :float)
    field(:first_down_percentage, :float)
    field(:over_twenty_yards, :float)
    field(:over_forty_yards, :float)
    field(:fumbles, :float)
  end

  def changeset(statistic, params \\ %{}) do
    fields = [
      :player_name,
      :player_team,
      :player_position,
      :attempts,
      :attempts_per_game_average,
      :total_yards,
      :yards_per_attempt_average,
      :yards_per_game,
      :total_rushing_touchdowns,
      :longest_rush,
      :first_downs,
      :first_down_percentage,
      :over_twenty_yards,
      :over_forty_yards,
      :fumbles
    ]

    statistic
    |> Ecto.Changeset.cast(params, fields)
    |> Ecto.Changeset.validate_required(fields)
  end
end
