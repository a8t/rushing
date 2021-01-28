import { merge, omit } from "lodash";
import { useRouter } from "next/router";

/**
 * Given a field name, render a button that will cycle between
 * a sort query param with asc, desc, and nothing.
 */
export function SortableColumnHeader({ label, fieldName }) {
  const router = useRouter();
  const { sort: currentSortQueryParam } = router.query;

  const handleSortClick = () => {
    const existingQuery = router.query;

    const nextSort = getNextSort(currentSortQueryParam, fieldName);

    router.push({
      pathname: router.pathname,
      query: nextSort
        ? merge(existingQuery, { sort: nextSort })
        : omit(existingQuery, ["sort"]),
    });
  };

  return (
    <button onClick={handleSortClick}>
      {label} {getSortSymbol(currentSortQueryParam, fieldName)}
    </button>
  );
}

function getCurrentSortForField(
  currentSortQueryParam: string,
  fieldName: string
) {
  if (!currentSortQueryParam) {
    return undefined;
  }

  const sortFields = Object.fromEntries(
    currentSortQueryParam
      .split(",")
      .map((eachSortField) => eachSortField.split(" "))
  );

  return sortFields[fieldName];
}

function getSortSymbol(currentSortQueryParam: string, fieldName) {
  const currentSortForField = getCurrentSortForField(
    currentSortQueryParam,
    fieldName
  );
  if (currentSortForField === undefined) {
    return " ↕";
  }
  return currentSortForField === "desc" ? " ↓" : " ↑";
}

function getNextSortForField(currentSortQueryParam: string, fieldName: string) {
  const currentSortForField = getCurrentSortForField(
    currentSortQueryParam,
    fieldName
  );

  return currentSortForField === undefined
    ? "asc"
    : currentSortForField === "asc"
    ? "desc"
    : undefined;
}

function getNextSort(currentSortQueryParam, fieldName) {
  if (!currentSortQueryParam) {
    return `${fieldName} asc`;
  }

  const sortFields = Object.fromEntries(
    currentSortQueryParam
      .split(",")
      .map((eachSortField) => eachSortField.split(" "))
  );

  const nextSortForField = getNextSortForField(
    currentSortQueryParam,
    fieldName
  );

  const nextSort =
    nextSortForField === undefined
      ? omit(sortFields, fieldName)
      : merge(sortFields, {
          [fieldName]: nextSortForField,
        });

  return queryStringifySort(nextSort);
}

function queryStringifySort(sortObject) {
  return Object.entries(sortObject)
    .map((eachPair) => eachPair.join(" "))
    .join(",");
}
