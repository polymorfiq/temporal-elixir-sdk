defmodule Temporal.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Temporal.ClientRegistry},
      {Registry, keys: :unique, name: Temporal.WorkerRegistry},
      {Registry, keys: :unique, name: Temporal.WorkflowRegistry},
      GRPC.Client.Supervisor,
      Temporal.Clients,
      Temporal.Environment
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Temporal.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
