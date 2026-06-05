defmodule Temporal.Supervisor.ClientList do
  use DynamicSupervisor

  def start_link(opts),
    do: DynamicSupervisor.start_link(__MODULE__, :ok, opts)

  @impl true
  def init(_init_arg), do: DynamicSupervisor.init(strategy: :one_for_one)
end
