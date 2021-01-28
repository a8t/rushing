import { useRouter } from "next/router";
import { debounce, omit } from "lodash";

export function PlayerNameFilter() {
  const router = useRouter();

  const handleInputChange = debounce((e) => {
    const newFilterValue = e.target.value;
    if (newFilterValue === "") {
      const existingQuery = {
        ...router.query,
        page: 1,
      };

      router.replace({
        pathname: router.pathname,
        query: omit(existingQuery, ["name_filter"]),
      });
    } else {
      router.replace({
        pathname: router.pathname,
        query: {
          ...router.query,
          name_filter: e.target.value,
          page: 1,
        },
      });
    }
  }, 200);

  return (
    <div className="ml-auto mr-8 relative">
      <label
        htmlFor="player_name"
        className="absolute -top-5 block text-sm font-medium text-gray-400"
      >
        Player filter
      </label>
      <input
        onChange={handleInputChange}
        type="text"
        name="player_name"
        id="player_name"
        className="mt-1 shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md"
        placeholder="Player McFootballerson"
      />
    </div>
  );
}
