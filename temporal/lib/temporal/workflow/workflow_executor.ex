defmodule Temporal.Workflow.WorkflowExecutor do
  use GenServer

  import TemporalEngine.Data.Failure

  alias TemporalEngine.Data.Payload
  alias Temporal.Supervisor.WorkflowSupervisor
  alias Temporal.Workflow
  alias Temporal.Workflow.WorkflowProgressReporter, as: Reporter
  alias Temporal.Workflow.WorkflowContext

  require Logger
  require Record

  Record.defrecordp(:workflow_state, [
    :id,
    :workflow_id,
    :worker_id,
    :module,
    :execute_fn,
    :exec_ctx,
    :args
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
       execute_fn: exec_ctx.workflow_execute_fn,
       exec_ctx: exec_ctx
     ), {:continue, :execute}}
  end

  def handle_continue(:execute, state) do
    Logger.debug(
      "Workflow started (ID: #{workflow_state(state, :workflow_id)}, Run ID: #{workflow_state(state, :id)}"
    )

    run_id = workflow_state(state, :id)
    mod = workflow_state(state, :module)
    execute_fn = workflow_state(state, :execute_fn)
    exec_ctx = workflow_state(state, :exec_ctx)

    with {:ok, reporter} <- WorkflowSupervisor.progress_reporter_pid(run_id),
         {:ok, ctx} <- WorkflowContext.new(exec_ctx) do
      inputs = Enum.map(workflow_state(state, :args), &Payload.value_from_record/1)

      try do
        case apply(mod, execute_fn, [ctx] ++ inputs) do
          {:ok, result} ->
            Logger.debug(
              "Workflow finished (ID: #{workflow_state(state, :workflow_id)}, Run ID: #{workflow_state(state, :id)} -> Reporting Completion..."
            )

            :ok = Reporter.report_completed_success(reporter, result)

          {:error, application() = err} ->
            :ok =
              Reporter.report_completed_failure(reporter,
                message: "Specific Application Error Returned... Check 'info'.",
                info: err
              )

          {:error, err} ->
            :ok =
              Reporter.report_completed_failure(reporter,
                message: "Returned error from workflow function",
                info:
                  application(
                    failure_type: Workflow.returned_error_type(),
                    details: [Payload.record_from_value(err)]
                  )
              )
        end
      rescue
        e ->
          Logger.debug(
            "Workflow finished (Exception) (ID: #{workflow_state(state, :workflow_id)}, Run ID: #{workflow_state(state, :id)}:\n#{Exception.format(:error, e, __STACKTRACE__)}"
          )

          :ok =
            Reporter.report_completed_failure(reporter,
              message: Exception.message(e),
              stack_trace: "#{Exception.format_stacktrace(__STACKTRACE__)}",
              info: application(failure_type: Atom.to_string(e.__struct__))
            )
      end

      {:noreply, state}
    else
      {:error, err} ->
        {:stop, {:error, err}, state}
    end
  end
end
