defmodule Temporal.Supervisor.ClientSupervisor do
  use Supervisor

  import TemporalEngine.Opts.ClientOpts, only: [connection_opts: 2]

  alias Temporal.ClientRegistry
  alias Temporal.Supervisor.WorkerList
  alias Temporal.CoreSdk.CoreClient

  def start_link({runtime_core, conn_opts, server_opts}),
    do: Supervisor.start_link(__MODULE__, {runtime_core, conn_opts}, server_opts)

  @impl true
  def init({runtime_core, conn_opts}) do
    identity = connection_opts(conn_opts, :identity)
    Process.set_label({:client_supervisor, identity})

    children = [
      {CoreClient, {runtime_core, conn_opts, [name: via_registry({:core, identity})]}},
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

  @spec stop_all_workers(client_identity :: String.t()) :: :ok
  def stop_all_workers(client_identity) do
    with {:ok, workers_sup} <- workers_sup_for_identity(client_identity) do
      DynamicSupervisor.which_children(workers_sup)
      |> Enum.each(fn
        {_, worker_sup, :supervisor, _} ->
          DynamicSupervisor.terminate_child(workers_sup, worker_sup)
          :ok

        _ ->
          :ok
      end)

      :ok
    else
      {:error, _} -> :ok
    end
  end

  defp via_registry(name), do: {:via, Registry, {ClientRegistry, name}}
end
