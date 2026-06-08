defmodule Temporal.Supervisor.ClientSupervisor do
  use Supervisor

  alias Temporal.ClientRegistry
  alias Temporal.Supervisor.WorkerList
  alias Temporal.CoreSdk.CoreClient

  def start_link({runtime_core, opts, server_opts}),
    do: Supervisor.start_link(__MODULE__, {runtime_core, opts}, server_opts)

  @impl true
  def init({runtime_core, opts}) do
    identity = opts.identity
    Process.set_label({:client_supervisor, identity})

    children = [
      {CoreClient, {runtime_core, opts, [name: via_registry({:core, identity})]}},
      {WorkerList, [name: via_registry({:workers, identity})]}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

  @spec workers_sup_for_identity(identity :: String.t()) :: {:ok, pid()} | {:error, term()}
  def workers_sup_for_identity(identity) do
    if pid = GenServer.whereis(via_registry({:workers, identity})) do
      {:ok, pid}
    else
      {:error, "Worker list not found for client (#{inspect(identity)})"}
    end
  end

  @spec core_for_identity(identity :: String.t()) :: {:ok, term()} | {:error, term()}
  def core_for_identity(identity),
    do: CoreClient.get_core(via_registry({:core, identity}))

  defp via_registry(name), do: {:via, Registry, {ClientRegistry, name}}
end
