defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.StartWorkflowExecutionResponse do
  @moduledoc """
  Automatically generated module for StartWorkflowExecutionResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`eager_workflow_task`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.PollWorkflowTaskQueueResponse` | When `request_eager_execution` is set on the `StartWorkflowExecutionRequest`, the server - if supported - will |
  | 4 | **`link`** | `Temporal.Protos.Temporal.Api.Common.V1.Link` | Link to the workflow event. |
  | 1 | **`run_id`** | `string` | The run id of the workflow that was started - or used (via WorkflowIdConflictPolicy USE_EXISTING). |
  | 3 | **`started`** | `bool` | If true, a new workflow was started. |
  | 5 | **`status`** | `Temporal.Protos.Temporal.Api.Enums.V1.WorkflowExecutionStatus` | Current execution status of the workflow. Typically remains WORKFLOW_EXECUTION_STATUS_RUNNING |

  ### Additional Notes

    * `eager_workflow_task` (`Temporal.Protos.Temporal.Api.Workflowservice.V1.PollWorkflowTaskQueueResponse`): When `request_eager_execution` is set on the `StartWorkflowExecutionRequest`, the server - if supported - will
      return the first workflow task to be eagerly executed.
      The caller is expected to have a worker available to process the task.
    * `status` (`Temporal.Protos.Temporal.Api.Enums.V1.WorkflowExecutionStatus`): Current execution status of the workflow. Typically remains WORKFLOW_EXECUTION_STATUS_RUNNING
      unless a de-dupe occurs or in specific scenarios handled within the ExecuteMultiOperation (refer to its docs).

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :run_id, 1, type: :string, json_name: "runId"
  field :started, 3, type: :bool

  field :status, 5,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkflowExecutionStatus,
    enum: true

  field :eager_workflow_task, 2,
    type: Temporal.Protos.Temporal.Api.Workflowservice.V1.PollWorkflowTaskQueueResponse,
    json_name: "eagerWorkflowTask"

  field :link, 4, type: Temporal.Protos.Temporal.Api.Common.V1.Link
end
