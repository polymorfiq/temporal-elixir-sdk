defmodule Temporal.Supervisor.ClientList do
  use DynamicSupervisor

  def start_link(opts),
    do: DynamicSupervisor.start_link(__MODULE__, :ok, opts)

  @impl true
  def init(_init_arg) do
    Process.set_label(:client_list)
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
