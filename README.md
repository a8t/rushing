# NFL Rushing

This repo contains two subdirectories:

- `api` is an Elixir back-end application
- `client` is a NextJS front-end application

## Quick Start

First, you'll need to install the following:

- PostgreSQL 13.1
- Node 14.11.0
- Elixir 1.11.1
- Erlang 23.1.1

Then clone the repo:

```bash
git clone https://github.com/a8t/rushing.git

cd rushing
```

In the `api` directory:
```bash
mix setup

mix phx.start
```


In the `client` directory:
```bash
yarn install

yarn start
```

## API
`api` is an Elixir umbrella app. It contains three apps in the umbrella:

- `:database` is an Ecto app
- `:rushing_web` is a Phoenix application that exposes a single JSON endpoint for getting Rushing Statistics.
- `:json_ingester` is a small OTP app that parses JSON data and persists it with `:database` - I didn't have to build this but I was curious about how it would be done! It would be cool to expose an HTTP interfaec for this (maybe even LiveView) as well.

I chose this structure because I wanted to experiment with umbrella apps and separating Phoenix from Ecto.

## Client

`client` is a NextJS app. NextJS is a React framework that gives some freebies like file-based routing, Typescript support, and other conveniences. Here's a menu of packages I installed to build it:

- **Typescript**: typed superset of JS. I use this to yell at me when I call a method that doesn't exist, etc. Unfortunately, not all the other libraries I used have good TS support.
- **TailwindCSS**: for styling. It's a CSS library that is used with a set of HTML classes. I've used it on a few projects.
- **React-Table**: a "headless" library that provides some state hooks for tables. It makes pagination, sorting, and filtering a total breeze.

Plus some helpers for downloading CSVs (which I've also implemented and didn't feel it was worth doing by hand again here), and for client-side filtering. More on this later.


# This is not optimized.

Right now, the app gets every single database record anytime a user looks at a table. The user experience would degrade significantly with larger sets of data. 

My plan is the following:

1. Turn pagination, filtering, sorting into URL query params on the client (why? so that users can go back to the same URL and get the same results instead of re-filtering and sorting every time)
2. Use URL params for getting paginated, filtered, sorted results from the API instead of fetching all records and getting them from the front end 🤪
3. Add a "change page size" feature