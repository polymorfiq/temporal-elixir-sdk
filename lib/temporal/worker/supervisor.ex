defmodule Temporal.Worker.Supervisor do
  use DynamicSupervisor

  def start_link(_init_arg \\ nil, sup_opts \\ []) do
    DynamicSupervisor.start_link(__MODULE__, nil, sup_opts)
  end

  @impl true
  def init(_init_arg), do: DynamicSupervisor.init(strategy: :one_for_one)
end
