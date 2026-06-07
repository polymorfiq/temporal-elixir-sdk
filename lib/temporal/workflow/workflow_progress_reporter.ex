defmodule Temporal.Workflow.WorkflowProgressReporter do
  use GenServer

  alias Temporal.CoreSdk.Data.WorkflowActivationCompletion
  alias Temporal.Supervisor.WorkerSupervisor
  alias Temporal.CoreSdk

  require Logger
  require Record
  Record.defrecordp(:progress_state, [:workflow_id, :worker_id, :initialize])

  def start_link({workflow_id, worker_id, initialize, server_opts}) do
    GenServer.start_link(__MODULE__, {workflow_id, worker_id, initialize}, server_opts)
  end

  def init({workflow_id, worker_id, initialize}) do
    {:ok, progress_state(workflow_id: workflow_id, worker_id: worker_id, initialize: initialize),
     {:continue, :started}}
  end

  def handle_continue(:started, state) do
    {:noreply, state}
  end

  def report_completed_success(reporter, results),
    do: GenServer.call(reporter, {:report_completed_success, results}, :infinity)

  def handle_call({:report_completed_success, results}, _from, state) do
    worker_id = progress_state(state, :worker_id)
    initialize = progress_state(state, :initialize)
    run_id = initialize.first_execution_run_id

    with {:ok, runtime} <- WorkerSupervisor.runtime_for_id(worker_id),
         {:ok, core_worker} <- WorkerSupervisor.core_for_id(worker_id) do
      completion =
        WorkflowActivationCompletion.with_opts!(
          run_id: run_id,
          status: {:successful, [commands: [{:complete_workflow_execution, [result: results]}]]}
        )

      :ok =
        CoreSdk._worker_complete_workflow_activation(
          runtime.core,
          core_worker.core,
          completion,
          self()
        )
    end

    {:reply, :ok, state}
  end
end
