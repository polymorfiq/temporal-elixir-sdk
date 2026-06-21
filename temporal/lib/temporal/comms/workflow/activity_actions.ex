defmodule Temporal.Comms.Workflow.ActivityActions do
  require Record
  import Temporal.Comms.WorkflowContext

  alias Temporal.Comms.WorkflowContext
  alias Temporal.Workflows.ActivityName

  Record.defrecordp(:activity_handle, [:activity_type, :run_id, :workflow_id])
  @opaque activity_handle :: record(:activity_handle, run_id: String.t())

  @spec execute_activity(WorkflowContext.workflow_context(), ActivityName.t(), [term()]) :: {:ok, activity_handle()} | {:error, term()}
  def execute_activity(ctx, name, _inputs) do
    activity_type = ActivityName.server_recognized_name(name)
    workflow_context(run_id: run_id, workflow_id: workflow_id) = ctx
    activity_handle(run_id: run_id, workflow_id: workflow_id, activity_type: activity_type)
  end

  def get(activity_handle() = _handle) do
  end
end
