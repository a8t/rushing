defmodule RushingWeb.RushingStatisticController do
  use RushingWeb, :controller

  alias RushingWeb.RushingStatisticController.Helper

  alias Database.Rushing
  alias Database.Rushing.RushingStatistic

  action_fallback RushingWeb.FallbackController

  def index(conn, params) do
    page = Map.get(params, "page", 1)
    page_size = Map.get(params, "page_size", 10)
    name_filter = Map.get(params, "name_filter", "")
    sort_kwlist = Helper.get_sort_kwlist(Map.get(params, "sort", ""))

    page =
      Rushing.list_rushing_statistics(:paged,
        page: page || 1,
        page_size: page_size || 10,
        name_filter: name_filter,
        sort: sort_kwlist
      )

    render(conn, "index.json",
      rushing_statistics: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
    )
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
