defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RequestCancelWorkflowExecutionRequest do
  @moduledoc """
  Automatically generated module for RequestCancelWorkflowExecutionRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`first_execution_run_id`** | `string` | If set, this call will error if the most recent (if no run id is set on |
  | 3 | **`identity`** | `string` | The identity of the worker/client |
  | 7 | **`links`** | `Temporal.Protos.Temporal.Api.Common.V1.Link` | Links to be associated with the WorkflowExecutionCanceled event. |
  | 1 | **`namespace`** | `string` |  |
  | 6 | **`reason`** | `string` | Reason for requesting the cancellation |
  | 4 | **`request_id`** | `string` | Used to de-dupe cancellation requests |
  | 2 | **`workflow_execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` |  |

  ### Additional Notes

    * `first_execution_run_id` (`string`): If set, this call will error if the most recent (if no run id is set on
      `workflow_execution`), or specified (if it is) workflow execution is not part of the same
      execution chain as this id.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string

  field :workflow_execution, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"

  field :identity, 3, type: :string
  field :request_id, 4, type: :string, json_name: "requestId"
  field :first_execution_run_id, 5, type: :string, json_name: "firstExecutionRunId"
  field :reason, 6, type: :string
  field :links, 7, repeated: true, type: Temporal.Protos.Temporal.Api.Common.V1.Link
end
