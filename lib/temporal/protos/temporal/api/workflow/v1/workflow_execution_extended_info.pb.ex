defmodule Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionExtendedInfo do
  @moduledoc """
  Holds all the extra information about workflow execution that is not part of Visibility.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`cancel_requested`** | `bool` | indicates if the workflow received a cancel request |
  | 1 | **`execution_expiration_time`** | `Google.Protobuf.Timestamp` | Workflow execution expiration time is defined as workflow start time plus expiration timeout. |
  | 4 | **`last_reset_time`** | `Google.Protobuf.Timestamp` | Last workflow reset time. Nil if the workflow was never reset. |
  | 5 | **`original_start_time`** | `Google.Protobuf.Timestamp` | Original workflow start time. |
  | 8 | **`pause_info`** | `Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionPauseInfo` | Information about the workflow execution pause operation. |
  | 7 | **`request_id_infos`** | `Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionExtendedInfo.RequestIdInfosEntry` | Request ID information (eg: history event information associated with the request ID). |
  | 6 | **`reset_run_id`** | `string` | Reset Run ID points to the new run when this execution is reset. If the execution is reset multiple times, it points to the latest run. |
  | 2 | **`run_expiration_time`** | `Google.Protobuf.Timestamp` | Workflow run expiration time is defined as current workflow run start time plus workflow run timeout. |

  ### Additional Notes

    * `execution_expiration_time` (`Google.Protobuf.Timestamp`): Workflow execution expiration time is defined as workflow start time plus expiration timeout.
      Workflow start time may change after workflow reset.
    * `request_id_infos` (`Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionExtendedInfo.RequestIdInfosEntry`): Request ID information (eg: history event information associated with the request ID).
      Note: It only contains request IDs from StartWorkflowExecution requests, including indirect
      calls (eg: if SignalWithStartWorkflowExecution starts a new workflow, then the request ID is
      used in the StartWorkflowExecution request).

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :execution_expiration_time, 1,
    type: Google.Protobuf.Timestamp,
    json_name: "executionExpirationTime"

  field :run_expiration_time, 2, type: Google.Protobuf.Timestamp, json_name: "runExpirationTime"
  field :cancel_requested, 3, type: :bool, json_name: "cancelRequested"
  field :last_reset_time, 4, type: Google.Protobuf.Timestamp, json_name: "lastResetTime"
  field :original_start_time, 5, type: Google.Protobuf.Timestamp, json_name: "originalStartTime"
  field :reset_run_id, 6, type: :string, json_name: "resetRunId"

  field :request_id_infos, 7,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionExtendedInfo.RequestIdInfosEntry,
    json_name: "requestIdInfos",
    map: true

  field :pause_info, 8,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionPauseInfo,
    json_name: "pauseInfo"
end
