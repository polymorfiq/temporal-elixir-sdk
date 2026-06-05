defmodule Temporal.Worker.WorkflowActivationPoller do
  use GenServer

  alias Temporal.Supervisor.WorkerSupervisor
  alias Temporal.CoreSdk.CoreWorker

  require Record
  Record.defrecordp(:poll_state, [:worker_id, :worker_pid, :core_worker, :core_runtime])

  def start_link({worker_id, server_opts}) do
    GenServer.start_link(__MODULE__, worker_id, server_opts)
  end

  @spec init({CoreRuntime.t(), CoreClient.t(), WorkerOpts.t()}) :: {:ok, pid()} | {:error, term()}
  def init(worker_id) do
    with {:ok, worker_pid} <- WorkerSupervisor.worker_pid(worker_id),
         {:ok, core} <- CoreWorker.get_core(worker_pid),
         {:ok, core_runtime} <- CoreWorker.get_runtime(worker_pid) do
      {:ok,
       poll_state(
         worker_id: worker_id,
         worker_pid: worker_pid,
         core_worker: core,
         core_runtime: core_runtime
       )}
    end
  end
end
