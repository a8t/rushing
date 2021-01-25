defmodule RushingWeb.RushingStatisticController do
  use RushingWeb, :controller

  alias Database.Rushing
  alias Database.Rushing.RushingStatistic

  action_fallback RushingWeb.FallbackController

  def index(conn, _params) do
    rushing_statistics = Rushing.list_rushing_statistics()
    render(conn, "index.json", rushing_statistics: rushing_statistics)
  end

  def create(conn, %{"rushing_statistic" => rushing_statistic_params}) do
    with {:ok, %RushingStatistic{} = rushing_statistic} <-
           Rushing.create_rushing_statistic(rushing_statistic_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.rushing_statistic_path(conn, :show, rushing_statistic)
      )
      |> render("show.json", rushing_statistic: rushing_statistic)
    end
  end

  # def show(conn, %{"id" => id}) do
  #   rushing_statistic = Rushing.get_rushing_statistic!(id)
  #   render(conn, "show.json", rushing_statistic: rushing_statistic)
  # end

  # def update(conn, %{"id" => id, "rushing_statistic" => rushing_statistic_params}) do
  #   rushing_statistic = Rushing.get_rushing_statistic!(id)

  #   with {:ok, %RushingStatistic{} = rushing_statistic} <-
  #          Rushing.update_rushing_statistic(rushing_statistic, rushing_statistic_params) do
  #     render(conn, "show.json", rushing_statistic: rushing_statistic)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   rushing_statistic = Database.get_rushing_statistic!(id)

  #   with {:ok, %RushingStatistic{}} <- Database.delete_rushing_statistic(rushing_statistic) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
