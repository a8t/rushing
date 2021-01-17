# Api

Assumes you have PostgeSQL installed.

1. Install dependencies
2. `mix ecto.create`
3. `mix ecto.migrate`
4. `mix ingest_json ./apps/json_ingester/lib/ingester/rushing.json`

Testing
1. `MIX_ENV=test mix ecto.create`
2. `MIX_ENV=test mix ecto.migrate`
