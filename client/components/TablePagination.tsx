import Link from "next/link";
import { useRouter } from "next/router";

export function TablePagination({ currentPage, totalPages }) {
  const router = useRouter();
  return (
    <nav
      className="bg-white px-4 py-3 flex items-center justify-between border-t border-gray-200 sm:px-6"
      aria-label="Pagination"
    >
      <div className="hidden sm:block">
        <p className="text-sm text-gray-700">
          Page <span className="font-medium">{currentPage}</span> of{" "}
          <span className="font-medium">{totalPages}</span>
        </p>
      </div>
      <div className="flex-1 flex justify-between sm:justify-end">
        <Link
          href={{
            pathname: router.pathname,
            query: {
              ...router.query,
              page: Math.max(currentPage - 1, 1),
            },
          }}
          scroll={false}
        >
          <button className="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
            Previous
          </button>
        </Link>
        <Link
          href={{
            pathname: router.pathname,
            query: {
              ...router.query,
              page: Math.min(currentPage + 1, totalPages),
            },
          }}
          scroll={false}
        >
          <button className="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
            Next
          </button>
        </Link>
      </div>
    </nav>
  );
}
