import React from "react";
import Head from "next/head";
import { Footer } from "../components/Footer";
import { Navbar } from "../components/Navbar";
import { Column, useTable } from "react-table";

import { TablePagination } from "../components/TablePagination";
import { PlayerNameFilter } from "../components/PlayerNameFilter";
import { SortableColumnHeader } from "../components/SortableColumnHeader";
import { useRouter } from "next/router";

export async function getServerSideProps(props) {
  const params = new URLSearchParams(props.query);
  const url = `${
    process.env.NEXT_PUBLIC_API_URL
  }/api/rushing_statistics?${params.toString()}`;

  const res = await fetch(url);

  const data = await res.json();

  if (!data) {
    return {
      notFound: true,
    };
  }

  return {
    props: {
      stats: data.data,
      pageNumber: data.page_number,
      pageSize: data.page_size,
      totalEntries: data.total_entries,
      totalPages: data.total_pages,
    }, // will be passed to the page component as props
  };
}

export default function Stats({
  stats,
  pageNumber,
  pageSize,
  totalEntries,
  totalPages,
}) {
  const memoizedData = React.useMemo(() => stats, [stats]);

  const columns: Column[] = React.useMemo(
    () => [
      {
        Header: "Player",
        accessor: "player_name",
        Cell: ({ row: { original } }) => {
          return (
            <div>
              <div className="text-sm font-medium text-gray-900">
                {original.player_name}
              </div>
              <div className="text-sm text-gray-500">
                {original.player_position} • {original.player_team}
              </div>
            </div>
          );
        },
      },
      { Header: "Att/G", accessor: "attempts" },
      {
        Header: "Att",
        accessor: "attempts_per_game_average",
      },
      {
        Header: () => (
          <SortableColumnHeader label="Yds" fieldName="total_yards" />
        ),
        accessor: "total_yards",
      },
      {
        Header: "Avg",
        accessor: "yards_per_attempt_average",
      },
      { Header: "Yds/G", accessor: "yards_per_game" },
      {
        Header: () => (
          <SortableColumnHeader
            label="TD"
            fieldName="total_rushing_touchdowns"
          />
        ),
        accessor: "total_rushing_touchdowns",
      },
      {
        Header: () => (
          <SortableColumnHeader label="Lng" fieldName="longest_rush" />
        ),
        accessor: "longest_rush",
      },
      { Header: "1st", accessor: "first_downs" },
      {
        Header: "1st%",
        accessor: "first_down_percentage",
      },
      { Header: "20+", accessor: "over_twenty_yards" },
      { Header: "40+", accessor: "over_forty_yards" },
      { Header: "FUM", accessor: "fumbles" },
    ],

    []
  );

  const {
    getTableProps,
    getTableBodyProps,
    headerGroups,
    prepareRow,
    rows,
  } = useTable({
    columns,
    data: memoizedData,
  });

  const router = useRouter();

  const queryString = Object.entries(router.query)
    .map(([key, value]) => key + "=" + value)
    .join("&");
  return (
    <div
      style={{ minHeight: "100vh", display: "flex", flexDirection: "column" }}
    >
      <Head>
        <title>NFL Rushing</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <Navbar />
      {/* This example requires Tailwind CSS v2.0+ */}

      <header className="py-10 bg-gray-800 pb-28">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex">
          <h1 className="text-3xl font-bold text-white">Rushing statistics</h1>
          <PlayerNameFilter />
          <a
            href={`${process.env.NEXT_PUBLIC_API_URL}/api/csv?${queryString}`}
            className="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
          >
            <button type="button">Export CSV</button>
          </a>
        </div>
      </header>

      <div style={{ flexGrow: 1 }} className="-mt-20">
        <div className="max-w-7xl mx-auto pb-12 px-4 sm:px-6 lg:px-8">
          <div className="flex flex-col">
            <div className="-my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
              <div className="py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8">
                <div className="shadow overflow-hidden border-b border-gray-200 sm:rounded-lg">
                  {totalPages > 1 ? (
                    <TablePagination
                      currentPage={pageNumber}
                      totalPages={totalPages}
                    />
                  ) : null}

                  <table
                    className="min-w-full divide-y divide-gray-200"
                    {...getTableProps()}
                  >
                    <thead className="bg-gray-50">
                      {headerGroups.map((headerGroup) => (
                        <tr {...headerGroup.getHeaderGroupProps()}>
                          {headerGroup.headers.map((column) => (
                            <th
                              {...column.getHeaderProps()}
                              scope="col"
                              className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                            >
                              {column.render("Header")}
                            </th>
                          ))}
                        </tr>
                      ))}
                    </thead>
                    <tbody {...getTableBodyProps()}>
                      {rows.length === 0 ? (
                        <tr className="relative h-24">
                          <td className="bg-gray-50 absolute inset-0 flex">
                            <div className="text-gray-500 m-auto">
                              Sorry, there are no results! Try changing the
                              filter.
                            </div>
                          </td>
                        </tr>
                      ) : null}
                      {rows.map((row, index) => {
                        prepareRow(row);
                        const isDarkRow = index % 2 === 0;

                        return (
                          <tr
                            {...row.getRowProps()}
                            className={isDarkRow ? "bg-gray-50" : "bg-white"}
                          >
                            {row.cells.map((cell) => {
                              return (
                                <td
                                  {...cell.getCellProps()}
                                  className="px-6 py-4 whitespace-nowrap text-sm  text-gray-900"
                                >
                                  {cell.render("Cell")}
                                </td>
                              );
                            })}
                          </tr>
                        );
                      })}
                    </tbody>
                  </table>
                  {totalPages > 1 ? (
                    <TablePagination
                      currentPage={pageNumber}
                      totalPages={totalPages}
                    />
                  ) : null}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <Footer />
    </div>
  );
}
