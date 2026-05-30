defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowPropertiesModifiedExternallyEventAttributes do
  @moduledoc """
  Not used anywhere. Use case is replaced by WorkflowExecutionOptionsUpdatedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`new_task_queue`** | `string` | Not used. |
  | 4 | **`new_workflow_execution_timeout`** | `Google.Protobuf.Duration` | Not used. |
  | 3 | **`new_workflow_run_timeout`** | `Google.Protobuf.Duration` | Not used. |
  | 2 | **`new_workflow_task_timeout`** | `Google.Protobuf.Duration` | Not used. |
  | 5 | **`upserted_memo`** | `Temporal.Protos.Temporal.Api.Common.V1.Memo` | Not used. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :new_task_queue, 1, type: :string, json_name: "newTaskQueue"

  field :new_workflow_task_timeout, 2,
    type: Google.Protobuf.Duration,
    json_name: "newWorkflowTaskTimeout"

  field :new_workflow_run_timeout, 3,
    type: Google.Protobuf.Duration,
    json_name: "newWorkflowRunTimeout"

  field :new_workflow_execution_timeout, 4,
    type: Google.Protobuf.Duration,
    json_name: "newWorkflowExecutionTimeout"

  field :upserted_memo, 5,
    type: Temporal.Protos.Temporal.Api.Common.V1.Memo,
    json_name: "upsertedMemo"
end
