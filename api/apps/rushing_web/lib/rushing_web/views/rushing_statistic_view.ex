defmodule RushingWeb.RushingStatisticView do
  use RushingWeb, :view

  def render("index.json", %{rushing_statistics: rushing_statistics}) do
    %{
      data:
        render_many(rushing_statistics, RushingWeb.RushingStatisticView, "rushing_statistic.json")
    }
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
