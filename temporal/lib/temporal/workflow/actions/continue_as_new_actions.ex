defmodule Temporal.Workflow.ContinueAsNewActions do
  require Record
  import Temporal.WorkflowContext
  require TemporalEngine.Data.Commands

  alias Temporal.WorkflowContext
  alias Temporal.Workflows.WorkflowName
  alias TemporalEngine.Data.Commands

  @spec continue_as_new_error!(
          WorkflowContext.t(),
          WorkflowName.t(),
          [term()],
          Commands.continue_as_new_workflow_execution_opts()
        ) :: Commands.continue_as_new_workflow_execution()
  def continue_as_new_error!(ctx, name, inputs, opts \\ []) do
    workflow_context(task_queue: task_queue) = ctx

    # Let's default to the current workflow's settings unless otherwise specified
    opts =
      Keyword.merge(
        [
          task_queue: task_queue,
          arguments: inputs
        ],
        opts
      )

    {:ok, workflow_type} = WorkflowName.server_recognized_name(name)
    opts = Keyword.merge([workflow_type: workflow_type], opts)
    Commands.continue_as_new_workflow_execution_from_opts!(opts)
  end
end
