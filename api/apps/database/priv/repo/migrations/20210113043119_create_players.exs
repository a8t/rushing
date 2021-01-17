defmodule Database.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:rushing_statistics) do
      add(:player_name, :string)
      add(:player_team, :string)
      add(:player_position, :string)
      add(:attempts, :float)
      add(:attempts_per_game_average, :float)
      add(:total_yards, :float)
      add(:yards_per_attempt_average, :float)
      add(:yards_per_game, :float)
      add(:total_rushing_touchdowns, :float)
      add(:longest_rush, :string)
      add(:first_downs, :float)
      add(:first_down_percentage, :float)
      add(:over_twenty_yards, :float)
      add(:over_forty_yards, :float)
      add(:fumbles, :float)
    end
  end
end
