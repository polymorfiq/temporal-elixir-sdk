defmodule Temporal.Workflow.WorkflowExecutor do
  use GenServer

  alias Temporal.CoreSdk.Data.Payload
  alias Temporal.CoreSdk.Data.WorkflowInput
  alias Temporal.Supervisor.WorkerSupervisor
  alias Temporal.Supervisor.WorkflowSupervisor
  alias Temporal.Workflow.WorkflowProgressReporter
  alias Temporal.Worker.WorkerWorkflowManager

  require Logger
  require Record
  Record.defrecordp(:workflow_state, [:id, :worker_id, :module, :initialize])

  def start_link({workflow_id, worker_id, workflow_module, initialize, server_opts}) do
    GenServer.start_link(
      __MODULE__,
      {workflow_id, worker_id, workflow_module, initialize},
      server_opts
    )
  end

  def init({workflow_id, worker_id, workflow_module, initialize}) do
    Process.flag(:trap_exit, true)

    {:ok,
     workflow_state(
       id: workflow_id,
       worker_id: worker_id,
       module: workflow_module,
       initialize: initialize
     ), {:continue, :execute}}
  end

  def handle_continue(:execute, state) do
    Logger.info("Workflow started: #{workflow_state(state, :id)}")

    workflow_id = workflow_state(state, :id)
    mod = workflow_state(state, :module)
    initialize = workflow_state(state, :initialize)

    with {:ok, reporter} <- WorkflowSupervisor.progress_reporter_pid(workflow_id) do
      inputs =
        Enum.map(initialize.arguments, fn
          %{metadata: %{"encoding" => ~c"json/plain"}, data: data} ->
            Jason.decode!(to_string(data))
        end)

      case apply(mod, :execute, [nil] ++ inputs) do
        {:ok, results} ->
          outputs = WorkflowInput.with_opts!(results) |> Payload.from_workflow_input()
          WorkflowProgressReporter.report_completed_success(reporter, outputs)
      end
    end

    {:noreply, state, {:continue, :complete}}
  end

  def handle_continue(:complete, state) do
    workflow_id = workflow_state(state, :id)
    worker_id = workflow_state(state, :worker_id)
    {:ok, manager} = WorkerSupervisor.workflow_manager_pid(worker_id)
    WorkerWorkflowManager.stop_workflow_with_id(manager, workflow_id)

    {:noreply, state}
  end
end
