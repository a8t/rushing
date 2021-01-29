defmodule RushingWeb.RushingStatisticView do
  import CSV
  use RushingWeb, :view

  def render("index.json", %{
        rushing_statistics: rushing_statistics,
        page_number: page_number,
        page_size: page_size,
        total_pages: total_pages,
        total_entries: total_entries
      }) do
    %{
      data:
        render_many(rushing_statistics, RushingWeb.RushingStatisticView, "rushing_statistic.json"),
      page_number: page_number,
      page_size: page_size,
      total_pages: total_pages,
      total_entries: total_entries
    }
  end

  def render("rushing_statistic.csv", %{
        rushing_statistics: rushing_statistics
      }) do
    csv_content = rushing_statistics

    [
      [
        "player_name",
        "player_team",
        "player_position",
        "attempts",
        "attempts_per_game_average",
        "total_yards",
        "yards_per_attempt_average",
        "yards_per_game",
        "total_rushing_touchdowns",
        "longest_rush",
        "first_downs",
        "first_down_percentage",
        "over_twenty_yards",
        "over_forty_yards",
        "fumbles"
      ]
    ]
    |> Stream.concat(
      rushing_statistics
      |> Stream.map(
        &[
          &1.player_name,
          &1.player_team,
          &1.player_position,
          &1.attempts,
          &1.attempts_per_game_average,
          &1.total_yards,
          &1.yards_per_attempt_average,
          &1.yards_per_game,
          &1.total_rushing_touchdowns,
          &1.longest_rush,
          &1.first_downs,
          &1.first_down_percentage,
          &1.over_twenty_yards,
          &1.over_forty_yards,
          &1.fumbles
        ]
      )
    )
    |> CSV.encode()
    |> Enum.to_list()
    |> to_string
  end

  # def render("show.json", %{rushing_statistic: rushing_statistic}) do
  #   %{
  #     data:
  #       render_one(rushing_statistic, RushingWeb.RushingStatisticView, "rushing_statistic.json")
  #   }
  # end

  def render("rushing_statistic.json", %{rushing_statistic: rushing_statistic}) do
    %{
      :player_name => rushing_statistic.player_name,
      :player_team => rushing_statistic.player_team,
      :player_position => rushing_statistic.player_position,
      :attempts => rushing_statistic.attempts,
      :attempts_per_game_average => rushing_statistic.attempts_per_game_average,
      :total_yards => rushing_statistic.total_yards,
      :yards_per_attempt_average => rushing_statistic.yards_per_attempt_average,
      :yards_per_game => rushing_statistic.yards_per_game,
      :total_rushing_touchdowns => rushing_statistic.total_rushing_touchdowns,
      :longest_rush => rushing_statistic.longest_rush,
      :first_downs => rushing_statistic.first_downs,
      :first_down_percentage => rushing_statistic.first_down_percentage,
      :over_twenty_yards => rushing_statistic.over_twenty_yards,
      :over_forty_yards => rushing_statistic.over_forty_yards,
      :fumbles => rushing_statistic.fumbles
    }
  end
end
