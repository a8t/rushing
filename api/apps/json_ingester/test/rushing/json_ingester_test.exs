defmodule Rushing.Json_IngesterTest do
  use ExUnit.Case
  doctest Rushing.JsonIngester

  alias Rushing.Database.RushingStatistic, as: RushingStatistic
  alias Rushing.Database.Repo

  import Ecto.Query, only: [from: 2]

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "ingests JSON" do
    {inserted_count, _} =
      Rushing.JsonIngester.ingest_json("#{__DIR__}/../../lib/ingester/rushing.json")

    rushing_statistic_count = Repo.one(from(r in RushingStatistic, select: count(r.id)))

    assert inserted_count == rushing_statistic_count
  end
end
