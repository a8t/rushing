defmodule Mix.Tasks.IngestJson do
  use Mix.Task

  @shortdoc "Ingests a JSON file and inserts it into the database"
  @moduledoc """
  Ingests a JSON file and inserts it into the database

  ## Example

  mix ingest ./example.json
  """

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")
    {inserted_count, _} = Rushing.JsonIngester.ingest_json(args)

    final_message = """

    > Ingested #{Path.relative_to_cwd(args)}
    > Inserted #{inserted_count} entries
    """

    Mix.shell().info(final_message)
  end
end
