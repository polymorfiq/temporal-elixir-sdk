defmodule Temporal.Workflow.ActivityActions do
  require Record
  import Temporal.Workflow.WorkflowContext
  import TemporalEngine.Data.Commands

  alias Temporal.Workflow.WorkflowExecution
  alias Temporal.Workflow.WorkflowContext
  alias Temporal.Workflows.ActivityName
  alias TemporalEngine.Data.Commands
  alias TemporalEngine.Data.Payload

  Record.defrecord(:activity_handle, [:seq, :execution])
  @opaque activity_handle :: record(:activity_handle, seq: pos_integer())

  @spec execute_activity(WorkflowContext.workflow_context(), ActivityName.t(), [term()], [
          Commands.schedule_activity_opt()
        ]) ::
          {:ok, activity_handle()} | {:error, term()}
  def execute_activity(ctx, name, inputs, opts \\ []) do
    workflow_context(execution: exec, task_queue: task_queue) = ctx

    {:current_stacktrace, full_stack} = Process.info(self(), :current_stacktrace)
    caller_stack = Enum.drop(full_stack, 2)

    if !opts[:schedule_to_close_timeout] && !opts[:start_to_close_timeout] do
      :erlang.raise(
        :error,
        %ArgumentError{
          message:
            ":schedule_to_close_timeout and/or :start_to_close_timeout must be specified when executing an activity."
        },
        caller_stack
      )
    end

    with {:ok, activity_type} <- ActivityName.server_recognized_name(name),
         {:ok, cmd} <-
           schedule_activity_from_opts(
             Keyword.merge([activity_type: activity_type, task_queue: task_queue], opts)
           ) do
      cmd = schedule_activity(cmd, arguments: Enum.map(inputs, &Payload.record_from_value/1))

      with {:ok, schedule_activity(seq: seq)} <- WorkflowExecution.queue_command(exec, cmd) do
        {:ok, activity_handle(seq: seq, execution: exec)}
      end
    end
  end

  def get(activity_handle(seq: seq, execution: exec)),
    do: WorkflowExecution.get_activity_results(exec, seq)
end
