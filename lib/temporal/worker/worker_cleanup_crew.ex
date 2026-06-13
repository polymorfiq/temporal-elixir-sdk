defmodule Temporal.Worker.WorkerCleanupCrew do
  use GenServer

  alias Temporal.CoreSdk.CoreWorker
  alias Temporal.Supervisor.WorkerSupervisor

  require Logger
  require Record

  Record.defrecordp(:cleanup_state, [
    :worker_id
  ])

  def start_link({exec_ctx, server_opts}) do
    GenServer.start_link(__MODULE__, exec_ctx, server_opts)
  end

  @spec init({CoreRuntime.t(), CoreClient.t(), WorkerOpts.t()}) :: {:ok, pid()} | {:error, term()}
  def init(exec_ctx) do
    Process.flag(:trap_exit, true)
    Process.set_label({:cleanup_crew, exec_ctx.worker_id})

    {:ok, cleanup_state(worker_id: exec_ctx.worker_id)}
  end

  def terminate(reason, state) do
    worker_id = cleanup_state(state, :worker_id)

    Logger.debug(
      "Cleanup Crew (#{worker_id}) terminating and ensuring shutdown... #{inspect(reason)}"
    )

    with {:ok, core_worker_pid} <- WorkerSupervisor.core_worker_pid(worker_id) do
      :ok = CoreWorker.shutdown(core_worker_pid)

      :shutdown
    else
      {:error, _} ->
        :shutdown
    end
  end
end
