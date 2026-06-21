defmodule Temporal.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @runtime_store Temporal.RuntimeLookup
  def runtime_store, do: @runtime_store

  @worker_store Temporal.WorkerLookup
  def worker_store, do: @worker_store

  @client_store Temporal.ClientLookup
  def client_store, do: @client_store

  @impl true
  def start(_type, _args) do
    Temporal.Storage.initialize!()

    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: Temporal.Workers},
      {Registry, keys: :unique, name: Temporal.TemporalRegistry}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Temporal.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
