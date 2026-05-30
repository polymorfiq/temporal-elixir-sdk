defmodule Temporal.Protos.Temporal.Api.Nexus.V1.NexusOperationExecutionListInfo do
  @moduledoc """
  Limited Nexus operation information returned in the list response.
  When adding fields here, ensure that it is also present in NexusOperationExecutionInfo (note that it may already be present in
  NexusOperationExecutionInfo but not at the top-level).

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 7 | **`close_time`** | `Google.Protobuf.Timestamp` | If the operation is in a terminal status, this field represents the time the operation transitioned to that status. |
  | 3 | **`endpoint`** | `string` | Endpoint name. |
  | 11 | **`execution_duration`** | `Google.Protobuf.Duration` | The difference between close time and scheduled time. |
  | 5 | **`operation`** | `string` | Operation name. |
  | 1 | **`operation_id`** | `string` | A unique identifier of this operation within its namespace along with run ID (below). |
  | 2 | **`run_id`** | `string` | The run ID of the standalone Nexus operation. |
  | 6 | **`schedule_time`** | `Google.Protobuf.Timestamp` | Time the operation was originally scheduled via a StartNexusOperation request. |
  | 9 | **`search_attributes`** | `Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes` | Search attributes from the start request. |
  | 4 | **`service`** | `string` | Service name. |
  | 12 | **`state_size_bytes`** | `int64` | Updated once on scheduled and once on terminal status. |
  | 10 | **`state_transition_count`** | `int64` | Updated on terminal status. |
  | 8 | **`status`** | `Temporal.Protos.Temporal.Api.Enums.V1.NexusOperationExecutionStatus` | The status is updated once, when the operation is originally scheduled, and again when the operation reaches a terminal status. |

  ### Additional Notes

    * `execution_duration` (`Google.Protobuf.Duration`): The difference between close time and scheduled time.
      This field is only populated if the operation is closed.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :operation_id, 1, type: :string, json_name: "operationId"
  field :run_id, 2, type: :string, json_name: "runId"
  field :endpoint, 3, type: :string
  field :service, 4, type: :string
  field :operation, 5, type: :string
  field :schedule_time, 6, type: Google.Protobuf.Timestamp, json_name: "scheduleTime"
  field :close_time, 7, type: Google.Protobuf.Timestamp, json_name: "closeTime"

  field :status, 8,
    type: Temporal.Protos.Temporal.Api.Enums.V1.NexusOperationExecutionStatus,
    enum: true

  field :search_attributes, 9,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"

  field :state_transition_count, 10, type: :int64, json_name: "stateTransitionCount"
  field :execution_duration, 11, type: Google.Protobuf.Duration, json_name: "executionDuration"
  field :state_size_bytes, 12, type: :int64, json_name: "stateSizeBytes"
end
