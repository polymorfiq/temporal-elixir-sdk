defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionCancelRequestedEventAttributes do
  @moduledoc """
  Automatically generated module for WorkflowExecutionCancelRequestedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`cause`** | `string` | User provided reason for requesting cancellation |
  | 2 | **`external_initiated_event_id`** | `int64` | The ID of the `REQUEST_CANCEL_EXTERNAL_WORKFLOW_EXECUTION_INITIATED` event in the external |
  | 3 | **`external_workflow_execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` |  |
  | 4 | **`identity`** | `string` | id of the worker or client who requested this cancel |

  ### Additional Notes

    * `external_initiated_event_id` (`int64`): The ID of the `REQUEST_CANCEL_EXTERNAL_WORKFLOW_EXECUTION_INITIATED` event in the external
      workflow history when the cancellation was requested by another workflow.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :cause, 1, type: :string
  field :external_initiated_event_id, 2, type: :int64, json_name: "externalInitiatedEventId"

  field :external_workflow_execution, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "externalWorkflowExecution"

  field :identity, 4, type: :string
end
