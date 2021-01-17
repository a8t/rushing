defmodule Rushing.Database.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Rushing.Database.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Rushing.Database.PubSub}
      # Start a worker by calling: Rushing.Database.Worker.start_link(arg)
      # {Rushing.Database.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Database.Supervisor)
  end
end
