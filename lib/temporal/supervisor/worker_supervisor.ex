defmodule Temporal.Supervisor.WorkerSupervisor do
  use Supervisor

  alias Temporal.WorkerRegistry
  alias Temporal.CoreSdk.CoreRuntime
  alias Temporal.CoreSdk.CoreClient
  alias Temporal.CoreSdk.CoreWorker
  alias Temporal.CoreSdk.Data.WorkerOpts

  @spec start_link(
          {worker_id :: String.t(), CoreRuntime.t(), CoreClient.t(), WorkerOpts.t(), keyword()}
        ) :: {:ok, pid()} | {:error, term()}
  def start_link({worker_id, runtime_core, client_core, opts, server_opts}) do
    Supervisor.start_link(__MODULE__, {worker_id, runtime_core, client_core, opts}, server_opts)
  end

  @impl true
  def init({worker_id, _runtime_core, _client_core, _opts}) do
    children = [
      {CoreWorker, {via_registry({:core, worker_id})}}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

  defp via_registry(name), do: {:via, Registry, {WorkerRegistry, name}}
end
