defmodule Temporal.Supervisor.WorkerList do
  use DynamicSupervisor

  def start_link(opts),
    do: DynamicSupervisor.start_link(__MODULE__, :ok, opts)

  @impl true
  def init(_init_arg) do
    Process.set_label(:worker_list)
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
