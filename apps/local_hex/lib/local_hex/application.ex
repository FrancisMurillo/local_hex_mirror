defmodule LocalHex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      LocalHex.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: LocalHex.PubSub}
      # Start a worker by calling: LocalHex.Worker.start_link(arg)
      # {LocalHex.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: LocalHex.Supervisor)
  end
end
