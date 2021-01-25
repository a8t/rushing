import React from "react";
import Head from "next/head";
import { Footer } from "../components/Footer";
import { Navbar } from "../components/Navbar";
import { useTable } from "react-table";

export async function getServerSideProps({ query }) {
  const url = process.env.NEXT_PUBLIC_API_URL + "/api/rushing_statistics";
  const res = await fetch(url);

  const data = await res.json();

  if (!data) {
    return {
      notFound: true,
    };
  }

  return {
    props: { stats: data.data }, // will be passed to the page component as props
  };
}

export default function Stats({ stats }) {
  const memoizedData = React.useMemo(() => stats, [stats]);

  const columns = React.useMemo(
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
      { Header: "Att", accessor: "attempts_per_game_average" },
      { Header: "Yds", accessor: "total_yards" },
      { Header: "Avg", accessor: "yards_per_attempt_average" },
      { Header: "Yds/G", accessor: "yards_per_game" },
      { Header: "TD", accessor: "total_rushing_touchdowns" },
      { Header: "Lng", accessor: "longest_rush" },
      { Header: "1st", accessor: "first_downs" },
      { Header: "1st%", accessor: "first_down_percentage" },
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
    rows,
    prepareRow,
  } = useTable({ columns, data: memoizedData });

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
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h1 className="text-3xl font-bold text-white">Rushing statistics</h1>
        </div>
      </header>

      <div style={{ flexGrow: 1 }} className="-mt-20">
        <div className="max-w-7xl mx-auto pb-12 px-4 sm:px-6 lg:px-8">
          <div className="flex flex-col">
            <div className="-my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
              <div className="py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8">
                <div className="shadow overflow-hidden border-b border-gray-200 sm:rounded-lg">
                  <table
                    className="min-w-full divide-y divide-gray-200"
                    {...getTableProps()}
                  >
                    <thead className="bg-gray-50">
                      {headerGroups.map((headerGroup) => (
                        <tr {...headerGroup.getHeaderGroupProps()}>
                          {
                            // Loop over the headers in each row

                            headerGroup.headers.map((column) => (
                              // Apply the header cell props

                              <th
                                {...column.getHeaderProps()}
                                scope="col"
                                className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                              >
                                {column.render("Header")}
                              </th>
                            ))
                          }
                        </tr>
                      ))}
                    </thead>
                    <tbody {...getTableBodyProps()}>
                      {
                        // Loop over the table rows

                        rows.map((row, index) => {
                          // Prepare the row for display

                          prepareRow(row);

                          const isDarkRow = index % 2 === 0;

                          return (
                            // Apply the row props

                            <tr
                              {...row.getRowProps()}
                              className={isDarkRow ? "bg-gray-50" : "bg-white"}
                            >
                              {
                                // Loop over the rows cells

                                row.cells.map((cell) => {
                                  // Apply the cell props

                                  return (
                                    <td
                                      {...cell.getCellProps()}
                                      className="px-6 py-4 whitespace-nowrap text-sm  text-gray-900"
                                    >
                                      {
                                        // Render the cell contents

                                        cell.render("Cell")
                                      }
                                    </td>
                                  );
                                })
                              }
                            </tr>
                          );
                        })
                      }
                    </tbody>
                  </table>
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
