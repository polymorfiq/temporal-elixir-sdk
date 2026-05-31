defmodule Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionConfig do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:task_queue, 1,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "taskQueue"
  )

  field(:workflow_execution_timeout, 2,
    type: Google.Protobuf.Duration,
    json_name: "workflowExecutionTimeout"
  )

  field(:workflow_run_timeout, 3, type: Google.Protobuf.Duration, json_name: "workflowRunTimeout")

  field(:default_workflow_task_timeout, 4,
    type: Google.Protobuf.Duration,
    json_name: "defaultWorkflowTaskTimeout"
  )

  field(:user_metadata, 5,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata,
    json_name: "userMetadata"
  )
end
