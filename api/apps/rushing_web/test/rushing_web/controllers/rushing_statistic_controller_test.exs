defmodule RushingWeb.RushingStatisticControllerTest do
  # Once the mode is manual, tests can also be async
  use ExUnit.Case, async: true
  use RushingWeb.ConnCase

  alias Database.Rushing
  alias RushingWeb.RushingStatisticController.Helper

  @create_attrs %{
    :player_name => "name",
    :player_team => "team",
    :player_position => "position",
    :attempts => 3.0,
    :attempts_per_game_average => 3.0,
    :total_yards => 3.0,
    :yards_per_attempt_average => 3.0,
    :yards_per_game => 3.0,
    :total_rushing_touchdowns => 3.0,
    :longest_rush => "3T",
    :first_downs => 3.0,
    :first_down_percentage => 3.0,
    :over_twenty_yards => 3.0,
    :over_forty_yards => 3.0,
    :fumbles => 3.0
  }

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Database.Repo)
  end

  def fixture(:rushing_statistic) do
    {:ok, rushing_statistic} = Rushing.create_rushing_statistic(@create_attrs)
    rushing_statistic
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all rushing_statistics", %{conn: conn} do
      conn = get(conn, Routes.rushing_statistic_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end

    test "lists all rushing_statistics after inserting", %{conn: conn} do
      {:ok, _rushing_statistic} = Rushing.create_rushing_statistic(@create_attrs)

      conn = get(conn, Routes.rushing_statistic_path(conn, :index))
      assert length(json_response(conn, 200)["data"]) == 1
    end

    test "lists all rushing_statistics, paginated", %{conn: conn} do
      # add 20 items to the DB
      for _i <- 1..20 do
        {:ok, _rushing_statistic} = Rushing.create_rushing_statistic(@create_attrs)
      end

      # assert that first page of 10 has 10 elements
      conn = get(conn, Routes.rushing_statistic_path(conn, :index, page: 1, page_size: 10))
      assert length(json_response(conn, 200)["data"]) == 10

      # assert that 2nd page of 15 has 5 elements
      conn = get(conn, Routes.rushing_statistic_path(conn, :index, page: 2, page_size: 15))
      assert length(json_response(conn, 200)["data"]) == 5
    end

    test "lists all rushing_statistics, filtered", %{conn: conn} do
      # add 20 items to the DB
      for i <- 1..20 do
        {:ok, _rushing_statistic} =
          Rushing.create_rushing_statistic(
            Map.merge(@create_attrs, %{:player_name => "name#{i}"})
          )
      end

      conn = get(conn, Routes.rushing_statistic_path(conn, :index, name_filter: "name17"))
      assert length(json_response(conn, 200)["data"]) == 1

      conn = get(conn, Routes.rushing_statistic_path(conn, :index, name_filter: "me2"))
      assert length(json_response(conn, 200)["data"]) == 2

      conn = get(conn, Routes.rushing_statistic_path(conn, :index, name_filter: "none"))
      assert length(json_response(conn, 200)["data"]) == 0
    end

    test "sorting by total yards", %{conn: conn} do
      # add 20 items to the DB
      for i <- 1..20 do
        {:ok, _rushing_statistic} =
          Rushing.create_rushing_statistic(Map.merge(@create_attrs, %{:total_yards => i / 1}))
      end

      conn =
        get(
          conn,
          Routes.rushing_statistic_path(conn, :index, page_size: 20, sort: "total_yards desc")
        )

      assert List.first(json_response(conn, 200)["data"])["total_yards"] == 20.0
      assert List.last(json_response(conn, 200)["data"])["total_yards"] == 1.0
    end

    test "sorting by total yards and longest rush", %{conn: conn} do
      for i <- 1..3 do
        for j <- 1..3 do
          Rushing.create_rushing_statistic(
            Map.merge(
              @create_attrs,
              %{:total_yards => i / 1, :total_rushing_touchdowns => j / 1}
            )
          )
        end
      end

      sort_query = "total_yards desc,total_rushing_touchdowns asc"

      conn = get(conn, Routes.rushing_statistic_path(conn, :index, sort: sort_query))

      data = json_response(conn, 200)["data"]

      first = List.first(data)
      second = Enum.at(data, 1)
      last = List.last(data)

      # should be in the order 3:1, 3:2, 3:3, 2:1, 2:2, 2:3, 3:1, 3:2, 3:3
      assert first["total_yards"] == 3.0
      assert second["total_rushing_touchdowns"] == 2.0
      assert first["total_rushing_touchdowns"] == 1.0
      assert last["total_rushing_touchdowns"] == 3.0
    end

    test "bad sort", %{conn: conn} do
      Rushing.create_rushing_statistic(@create_attrs)
      Rushing.create_rushing_statistic(@create_attrs)

      sort_query = "total_yards desc,total_dfsdfsrushing_touchdowns asc"

      conn = get(conn, Routes.rushing_statistic_path(conn, :index, sort: sort_query))

      data = json_response(conn, 200)["data"]

      assert length(data) == 2
    end
  end

  describe "get_sort_kwlist" do
    test "works with one sort query param" do
      sort_kwlist = Helper.get_sort_kwlist("total_yards asc")

      assert length(sort_kwlist) == 1
    end

    test "works with multiple sort query params" do
      sort_kwlist = Helper.get_sort_kwlist("total_yards asc,longest_rush desc")

      assert length(sort_kwlist) == 2
    end

    test "ignores bad sort query params" do
      sort_kwlist = Helper.get_sort_kwlist("total_yards asc,bad_field desc")

      assert length(sort_kwlist) == 1
    end
  end

  describe "get csv" do
    test "works", %{conn: conn} do
      {:ok, _rushing_statistic} = Rushing.create_rushing_statistic(@create_attrs)

      conn = get(conn, Routes.rushing_statistic_path(conn, :export_csv))

      assert is_binary(conn.resp_body) == true

      [headers, body] =
        conn.resp_body
        |> String.split("\n")
        |> Enum.take(2)

      assert List.first(String.split(headers, ",")) == "player_name"
      assert List.first(String.split(body, ",")) == "name"
    end
  end

  # describe "create rushing_statistic" do
  #   test "renders rushing_statistic when data is valid", %{conn: conn} do
  #     conn =
  #       post(conn, Routes.rushing_statistic_path(conn, :create), rushing_statistic: @create_attrs)

  #     assert %{"id" => id} = json_response(conn, 201)["data"]

  #     conn = get(conn, Routes.rushing_statistic_path(conn, :show, id))

  #     assert %{
  #              "id" => id
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn =
  #       post(conn, Routes.rushing_statistic_path(conn, :create), rushing_statistic: @invalid_attrs)

  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "update rushing_statistic" do
  #   setup [:create_rushing_statistic]

  #   test "renders rushing_statistic when data is valid", %{conn: conn, rushing_statistic: %RushingStatistic{id: id} = rushing_statistic} do
  #     conn = put(conn, Routes.rushing_statistic_path(conn, :update, rushing_statistic), rushing_statistic: @update_attrs)
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get(conn, Routes.rushing_statistic_path(conn, :show, id))

  #     assert %{
  #              "id" => id
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, rushing_statistic: rushing_statistic} do
  #     conn = put(conn, Routes.rushing_statistic_path(conn, :update, rushing_statistic), rushing_statistic: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete rushing_statistic" do
  #   setup [:create_rushing_statistic]

  #   test "deletes chosen rushing_statistic", %{conn: conn, rushing_statistic: rushing_statistic} do
  #     conn = delete(conn, Routes.rushing_statistic_path(conn, :delete, rushing_statistic))
  #     assert response(conn, 204)

  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.rushing_statistic_path(conn, :show, rushing_statistic))
  #     end
  #   end
  # end

  # defp create_rushing_statistic(_) do
  #   rushing_statistic = fixture(:rushing_statistic)
  #   %{rushing_statistic: rushing_statistic}
  # end
end
