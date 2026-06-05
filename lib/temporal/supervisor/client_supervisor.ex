defmodule Temporal.Supervisor.ClientSupervisor do
  use Supervisor

  def start_link(identity, opts),
    do: Supervisor.start_link(__MODULE__, identity, opts)

  @impl true
  def init(identity) do
    children = [
      {Temporal.Supervisor.WorkerList,
       [name: {:via, Registry, {Temporal.Clients, {:worker_list, identity}}}]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
