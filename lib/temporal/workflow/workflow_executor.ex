defmodule Temporal.Workflow.WorkflowExecutor do
  use GenServer

  alias Temporal.Comms.Payload
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
    :args,
    :initialize
  ])

  def start_link({exec_ctx, args, server_opts}) do
    GenServer.start_link(
      __MODULE__,
      {exec_ctx, args},
      server_opts
    )
  end

  def init({exec_ctx, args}) do
    Process.set_label({:workflow_executor, exec_ctx.run_id})
    Process.flag(:trap_exit, true)

    {:ok,
     workflow_state(
       id: exec_ctx.run_id,
       args: args,
       workflow_id: exec_ctx.workflow_id,
       worker_id: exec_ctx.worker_id,
       module: exec_ctx.workflow_module,
       exec_ctx: exec_ctx,
       initialize: exec_ctx.workflow_initialize
     ), {:continue, :execute}}
  end

  def handle_continue(:execute, state) do
    Logger.debug(
      "Workflow started (ID: #{workflow_state(state, :workflow_id)}, Run ID: #{workflow_state(state, :id)}"
    )

    run_id = workflow_state(state, :id)
    mod = workflow_state(state, :module)
    exec_ctx = workflow_state(state, :exec_ctx)

    with {:ok, reporter} <- WorkflowSupervisor.progress_reporter_pid(run_id),
         {:ok, ctx} <- WorkflowContext.new(exec_ctx) do
      inputs = Enum.map(workflow_state(state, :args), &Payload.to_value/1)

      case apply(mod, :execute, [ctx] ++ inputs) do
        {:ok, result} ->
          Logger.debug(
            "Workflow finished (ID: #{workflow_state(state, :workflow_id)}, Run ID: #{workflow_state(state, :id)} -> Reporting Completion..."
          )

          :ok = WorkflowProgressReporter.report_completed_success(reporter, result)
      end

      {:noreply, state}
    else
      {:error, err} ->
        {:stop, {:error, err}, state}
    end
  end
end
