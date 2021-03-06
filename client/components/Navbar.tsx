import { useRouter } from "next/router";
import Link from "next/link";
import { useState } from "react";

export function cn(...args) {
  return args.filter(Boolean).join(" ");
}

function ActiveLink({ children, href }) {
  const router = useRouter();
  return (
    <Link passHref href={href}>
      {children({ isActive: router.pathname === href })}
    </Link>
  );
}

function DesktopLink({ children, href }) {
  return (
    <ActiveLink href={href}>
      {({ isActive }) => (
        <a
          className={cn(
            "px-3 py-2 rounded-md text-sm font-medium",
            isActive
              ? "bg-gray-900 text-white hover:text-white "
              : "text-gray-300 hover:bg-gray-700 "
          )}
        >
          {children}
        </a>
      )}
    </ActiveLink>
  );
}
function MobileLink({ children, href }) {
  return (
    <ActiveLink href={href}>
      {({ isActive }) => (
        <a
          className={cn(
            "block px-3 py-2 rounded-md text-base font-medium",
            isActive
              ? "bg-gray-900 text-white hover:text-white "
              : "text-gray-300 hover:bg-gray-700 "
          )}
        >
          {children}
        </a>
      )}
    </ActiveLink>
  );
}

export function Navbar() {
  const [isMobileMenueOpen, setIsMobileMenueOpen] = useState(false);

  return (
    <nav className="bg-gray-800">
      <div className="max-w-7xl mx-auto px-2 sm:px-6 lg:px-8">
        <div className="relative flex items-center justify-between h-16">
          <div className="absolute inset-y-0 left-0 flex items-center sm:hidden">
            {/* Mobile menu button*/}
            <button
              className="inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-white hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white"
              aria-expanded="false"
              onClick={() => setIsMobileMenueOpen(!isMobileMenueOpen)}
            >
              <span className="sr-only">Open main menu</span>
              {isMobileMenueOpen ? (
                <svg
                  className=" h-6 w-6"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                  aria-hidden="true"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M6 18L18 6M6 6l12 12"
                  />
                </svg>
              ) : (
                <svg
                  className=" h-6 w-6"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                  aria-hidden="true"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M4 6h16M4 12h16M4 18h16"
                  />
                </svg>
              )}
            </button>
          </div>
          <div className="flex-1 flex items-center justify-center sm:items-stretch sm:justify-start">
            <div className="flex-shrink-0 flex items-center">
              <img
                className="block  h-8 w-auto"
                src="https://tailwindui.com/img/logos/workflow-mark-indigo-500.svg"
                alt="Workflow"
              />
            </div>
            <div className="hidden sm:block sm:ml-6">
              <div className="flex space-x-4">
                {/* Current: "bg-gray-900 text-white", Default: "text-gray-300 hover:bg-gray-700 hover:text-white" */}
                <DesktopLink href="/">Home</DesktopLink>
                <DesktopLink href="/stats">Stats</DesktopLink>
              </div>
            </div>
          </div>
          <div className="absolute inset-y-0 right-0 flex items-center pr-2 sm:static sm:inset-auto sm:ml-6 sm:pr-0">
            <button className="bg-gray-800 p-1 rounded-full text-gray-400 hover:text-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-800 focus:ring-white">
              <span className="sr-only">View notifications</span>
              {/* Heroicon name: bell */}
              <svg
                className="h-6 w-6"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
                aria-hidden="true"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"
                />
              </svg>
            </button>{" "}
          </div>
        </div>
      </div>
      {/*
    Mobile menu, toggle classes based on menu state.

    Menu open: "block", Menu closed: "hidden"
  */}

      <div className={cn("sm:hidden", isMobileMenueOpen ? "block" : "hidden")}>
        <div className="px-2 pt-2 pb-3 space-y-1">
          <MobileLink href="/">Home</MobileLink>
          <MobileLink href="/stats">Stats</MobileLink>
        </div>
      </div>
    </nav>
  );
}
