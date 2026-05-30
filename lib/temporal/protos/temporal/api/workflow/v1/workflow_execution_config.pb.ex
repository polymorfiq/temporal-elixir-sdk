defmodule Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionConfig do
  @moduledoc """
  Automatically generated module for WorkflowExecutionConfig

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`default_workflow_task_timeout`** | `Google.Protobuf.Duration` |  |
  | 1 | **`task_queue`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue` |  |
  | 5 | **`user_metadata`** | `Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata` | User metadata provided on start workflow. |
  | 2 | **`workflow_execution_timeout`** | `Google.Protobuf.Duration` |  |
  | 3 | **`workflow_run_timeout`** | `Google.Protobuf.Duration` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :task_queue, 1,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "taskQueue"

  field :workflow_execution_timeout, 2,
    type: Google.Protobuf.Duration,
    json_name: "workflowExecutionTimeout"

  field :workflow_run_timeout, 3, type: Google.Protobuf.Duration, json_name: "workflowRunTimeout"

  field :default_workflow_task_timeout, 4,
    type: Google.Protobuf.Duration,
    json_name: "defaultWorkflowTaskTimeout"

  field :user_metadata, 5,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata,
    json_name: "userMetadata"
end
