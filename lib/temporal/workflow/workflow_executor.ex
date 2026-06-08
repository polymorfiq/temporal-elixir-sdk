defmodule Temporal.Workflow.WorkflowExecutor do
  use GenServer

  alias Temporal.Supervisor.WorkflowSupervisor
  alias Temporal.Workflow.WorkflowProgressReporter
  alias Temporal.Workflow.WorkflowContext

  require Logger
  require Record

  Record.defrecordp(:workflow_state, [
    :id,
    :workflow_id,
    :worker_id,
    :module,
    :exec_ctx,
    :initialize
  ])

  def start_link({exec_ctx, initialize, server_opts}) do
    GenServer.start_link(
      __MODULE__,
      {exec_ctx, initialize},
      server_opts
    )
  end

  def init({exec_ctx, initialize}) do
    Process.set_label({:workflow_executor, exec_ctx.run_id})
    Process.flag(:trap_exit, true)

    {:ok,
     workflow_state(
       id: exec_ctx.run_id,
       workflow_id: exec_ctx.workflow_id,
       worker_id: exec_ctx.worker_id,
       module: exec_ctx.workflow_module,
       exec_ctx: exec_ctx,
       initialize: initialize
     ), {:continue, :execute}}
  end

  def handle_continue(:execute, state) do
    Logger.info(
      "Workflow started (ID: #{workflow_state(state, :workflow_id)}, Run ID: #{workflow_state(state, :id)}"
    )

    run_id = workflow_state(state, :id)
    mod = workflow_state(state, :module)
    initialize = workflow_state(state, :initialize)
    exec_ctx = workflow_state(state, :exec_ctx)

    with {:ok, reporter} <- WorkflowSupervisor.progress_reporter_pid(run_id),
         {:ok, ctx} <- WorkflowContext.new(exec_ctx) do
      inputs =
        Enum.map(initialize.arguments, fn
          %{metadata: %{"encoding" => ~c"json/plain"}, data: data} ->
            Jason.decode!(to_string(data))
        end)

      case apply(mod, :execute, [ctx] ++ inputs) do
        {:ok, result} ->
          Logger.info(
            "Workflow finished (ID: #{workflow_state(state, :workflow_id)}, Run ID: #{workflow_state(state, :id)} -> Reporting Completion..."
          )

          WorkflowProgressReporter.report_completed_success(reporter, result)
      end

      {:noreply, state, {:continue, :complete}}
    else
      {:error, err} -> {:shutdown, {:error, err}}
    end
  end

  def handle_continue(:complete, state) do
    run_id = workflow_state(state, :id)
    WorkflowSupervisor.stop_workflow(run_id)

    {:noreply, state}
  end
end
