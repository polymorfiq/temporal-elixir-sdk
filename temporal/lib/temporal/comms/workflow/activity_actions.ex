defmodule Temporal.Comms.Workflow.ActivityActions do
  require Record
  import Temporal.Comms.WorkflowContext
  import TemporalEngine.Data.Commands

  alias Temporal.Comms.Workflow.WorkflowExecution
  alias Temporal.Comms.WorkflowContext
  alias Temporal.Workflows.ActivityName
  alias TemporalEngine.Data.Commands
  alias TemporalEngine.Data.Payload

  Record.defrecordp(:activity_handle, [:seq])
  @opaque activity_handle :: record(:activity_handle, seq: pos_integer())

  @spec execute_activity(WorkflowContext.workflow_context(), ActivityName.t(), [term()], [
          Commands.schedule_activity_opt()
        ]) ::
          {:ok, activity_handle()} | {:error, term()}
  def execute_activity(ctx, name, inputs, opts \\ []) do
    workflow_context(execution: exec, task_queue: task_queue) = ctx

    with {:ok, activity_type} <- ActivityName.server_recognized_name(name),
         {:ok, cmd} <-
           schedule_activity_from_opts(
             [activity_type: activity_type, task_queue: task_queue] ++ opts
           ) do
      cmd = schedule_activity(cmd, arguments: Enum.map(inputs, &Payload.record_from_value/1))

      with {:ok, schedule_activity(seq: seq)} <- WorkflowExecution.queue_command(exec, cmd) do
        {:ok, activity_handle(seq: seq)}
      end
    end
  end

  def get(activity_handle() = _handle) do
  end
end
