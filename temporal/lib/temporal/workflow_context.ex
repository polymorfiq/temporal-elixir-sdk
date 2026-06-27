defmodule Temporal.WorkflowContext do
  require Record

  alias TemporalEngine.Data.Commands

  Record.defrecord(:workflow_context, [
    :execution,
    :task_queue,
    :workflow_id,
    :namespace,
    :run_id,
    activity_options: [],
    child_workflow_options: []
  ])

  @type t :: workflow_context()

  @type workflow_context ::
          record(:workflow_context,
            execution: pid(),
            task_queue: String.t(),
            workflow_id: String.t(),
            namespace: String.t(),
            run_id: String.t(),
            activity_options: Commands.schedule_activity_opts(),
            child_workflow_options: Commands.start_child_workflow_execution_opts()
          )
end
