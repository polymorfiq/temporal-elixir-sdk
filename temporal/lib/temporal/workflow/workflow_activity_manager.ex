defmodule Temporal.Workflow.WorkflowActivityManager do
  use GenServer

  alias Temporal.ActivityRegistry
  alias Temporal.CoreSdk.CoreWorker
  alias Temporal.Supervisor.ActivitySupervisor
  alias Temporal.Supervisor.ExecutionContext
  alias Temporal.Supervisor.WorkerSupervisor

  require Logger
  require Record

  Record.defrecordp(:activities_state, [:worker_id, :exec_ctx])

  def start_link({exec_ctx, server_opts}) do
    GenServer.start_link(__MODULE__, exec_ctx, server_opts)
  end

  @spec init(ExecutionContext.t()) :: {:ok, pid()} | {:error, term()}
  def init(exec_ctx) do
    Process.set_label({:activity_manager, exec_ctx.worker_id})
    {:ok, activities_state(worker_id: exec_ctx.worker_id, exec_ctx: exec_ctx)}
  end

  @spec start_or_restart_activity(ExecutionContext.t()) :: :ok | {:error, term()}
  def start_or_restart_activity(exec_ctx) do
    with {:ok, activities_sup} <- WorkerSupervisor.activities_sup_for_id(exec_ctx.worker_id),
         {:ok, core_worker} <- CoreWorker.existing_for_id(exec_ctx.worker_id) do
      DynamicSupervisor.start_child(
        activities_sup,
        Supervisor.child_spec(
          {ActivitySupervisor,
           {
             %{exec_ctx | core_worker: core_worker},
             [name: ActivitySupervisor.process_name(exec_ctx.run_id, exec_ctx.activity_id)]
           }},
          restart: :temporary
        )
      )
      |> case do
        {:ok, _} ->
          :ok

        {:error, {:already_started, _}} ->
          ActivitySupervisor.stop_activity(exec_ctx.run_id, wait: true)
          start_or_restart_activity(exec_ctx)

        {:error, err} ->
          {:error, err}
      end
    end
  end

  @spec process_name(run_id :: String.t(), activity_id :: String.t()) :: {:via, atom(), term()}
  def process_name(run_id, activity_id) do
    {:via, Registry, {ActivityRegistry, {:activity, run_id, activity_id}}}
  end
end
