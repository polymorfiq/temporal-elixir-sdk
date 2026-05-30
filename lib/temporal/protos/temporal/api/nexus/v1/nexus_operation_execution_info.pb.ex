defmodule Temporal.Protos.Temporal.Api.Nexus.V1.NexusOperationExecutionInfo do
  @moduledoc """
  Full current state of a standalone Nexus operation, as of the time of the request.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 11 | **`attempt`** | `int32` | The number of attempts made to deliver the start operation request. |
  | 20 | **`blocked_reason`** | `string` | If the state is BLOCKED, blocked reason provides additional information. |
  | 19 | **`cancellation_info`** | `Temporal.Protos.Temporal.Api.Nexus.V1.NexusOperationExecutionCancellationInfo` |  |
  | 14 | **`close_time`** | `Google.Protobuf.Timestamp` | Time when the operation transitioned to a closed state. |
  | 3 | **`endpoint`** | `string` | Endpoint name, resolved to a URL via the cluster's endpoint registry. |
  | 18 | **`execution_duration`** | `Google.Protobuf.Duration` | Elapsed time from schedule_time to now for running operations or to close_time for closed |
  | 13 | **`expiration_time`** | `Google.Protobuf.Timestamp` | Scheduled time + schedule to close timeout. |
  | 28 | **`identity`** | `string` | The identity of the client who started this operation. |
  | 15 | **`last_attempt_complete_time`** | `Google.Protobuf.Timestamp` | The time when the last attempt completed. |
  | 16 | **`last_attempt_failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | The last attempt's failure, if any. |
  | 27 | **`links`** | `Temporal.Protos.Temporal.Api.Common.V1.Link` | Links attached by the handler of this operation on start or completion. |
  | 17 | **`next_attempt_schedule_time`** | `Google.Protobuf.Timestamp` | The time when the next attempt is scheduled. |
  | 25 | **`nexus_header`** | `Temporal.Protos.Temporal.Api.Nexus.V1.NexusOperationExecutionInfo.NexusHeaderEntry` | Header for context propagation and tracing purposes. |
  | 5 | **`operation`** | `string` | Operation name. |
  | 1 | **`operation_id`** | `string` | Unique identifier of this Nexus operation within its namespace along with run ID (below). |
  | 22 | **`operation_token`** | `string` | Operation token. Only set for asynchronous operations after a successful StartOperation call. |
  | 21 | **`request_id`** | `string` | Server-generated request ID used as an idempotency token when submitting start requests to |
  | 2 | **`run_id`** | `string` |  |
  | 12 | **`schedule_time`** | `Google.Protobuf.Timestamp` | Time the operation was originally scheduled via a StartNexusOperation request. |
  | 8 | **`schedule_to_close_timeout`** | `Google.Protobuf.Duration` | Schedule-to-close timeout for this operation. |
  | 9 | **`schedule_to_start_timeout`** | `Google.Protobuf.Duration` | Schedule-to-start timeout for this operation. |
  | 24 | **`search_attributes`** | `Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes` |  |
  | 4 | **`service`** | `string` | Service name. |
  | 10 | **`start_to_close_timeout`** | `Google.Protobuf.Duration` | Start-to-close timeout for this operation. |
  | 7 | **`state`** | `Temporal.Protos.Temporal.Api.Enums.V1.PendingNexusOperationState` | More detailed breakdown of NEXUS_OPERATION_EXECUTION_STATUS_RUNNING. |
  | 29 | **`state_size_bytes`** | `int64` | Updated once on scheduled and once on terminal status. |
  | 23 | **`state_transition_count`** | `int64` | Incremented each time the operation's state is mutated in persistence. |
  | 6 | **`status`** | `Temporal.Protos.Temporal.Api.Enums.V1.NexusOperationExecutionStatus` | A general status for this operation, indicates whether it is currently running or in one of the terminal statuses. |
  | 26 | **`user_metadata`** | `Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata` | Metadata for use by user interfaces to display the fixed as-of-start summary and details of the operation. |

  ### Additional Notes

    * `attempt` (`int32`): The number of attempts made to deliver the start operation request.
      This number is approximate, it is incremented when a task is added to the history queue.
      In practice, there could be more attempts if a task is executed but fails to commit, or less attempts if a task
      was never executed.
    * `execution_duration` (`Google.Protobuf.Duration`): Elapsed time from schedule_time to now for running operations or to close_time for closed
      operations, including all attempts and backoff between attempts.
    * `request_id` (`string`): Server-generated request ID used as an idempotency token when submitting start requests to
      the handler. Distinct from the request_id in StartNexusOperationRequest, which is the
      caller-side idempotency key for the StartNexusOperation RPC itself.
    * `schedule_to_close_timeout` (`Google.Protobuf.Duration`): Schedule-to-close timeout for this operation.
      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "to" is used to indicate interval. --)
    * `schedule_to_start_timeout` (`Google.Protobuf.Duration`): Schedule-to-start timeout for this operation.
      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "to" is used to indicate interval. --)
    * `start_to_close_timeout` (`Google.Protobuf.Duration`): Start-to-close timeout for this operation.
      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "to" is used to indicate interval. --)
    * `status` (`Temporal.Protos.Temporal.Api.Enums.V1.NexusOperationExecutionStatus`): A general status for this operation, indicates whether it is currently running or in one of the terminal statuses.
      Updated once when the operation is originally scheduled, and again when it reaches a terminal status.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :operation_id, 1, type: :string, json_name: "operationId"
  field :run_id, 2, type: :string, json_name: "runId"
  field :endpoint, 3, type: :string
  field :service, 4, type: :string
  field :operation, 5, type: :string

  field :status, 6,
    type: Temporal.Protos.Temporal.Api.Enums.V1.NexusOperationExecutionStatus,
    enum: true

  field :state, 7,
    type: Temporal.Protos.Temporal.Api.Enums.V1.PendingNexusOperationState,
    enum: true

  field :schedule_to_close_timeout, 8,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToCloseTimeout"

  field :schedule_to_start_timeout, 9,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToStartTimeout"

  field :start_to_close_timeout, 10,
    type: Google.Protobuf.Duration,
    json_name: "startToCloseTimeout"

  field :attempt, 11, type: :int32
  field :schedule_time, 12, type: Google.Protobuf.Timestamp, json_name: "scheduleTime"
  field :expiration_time, 13, type: Google.Protobuf.Timestamp, json_name: "expirationTime"
  field :close_time, 14, type: Google.Protobuf.Timestamp, json_name: "closeTime"

  field :last_attempt_complete_time, 15,
    type: Google.Protobuf.Timestamp,
    json_name: "lastAttemptCompleteTime"

  field :last_attempt_failure, 16,
    type: Temporal.Protos.Temporal.Api.Failure.V1.Failure,
    json_name: "lastAttemptFailure"

  field :next_attempt_schedule_time, 17,
    type: Google.Protobuf.Timestamp,
    json_name: "nextAttemptScheduleTime"

  field :execution_duration, 18, type: Google.Protobuf.Duration, json_name: "executionDuration"

  field :cancellation_info, 19,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.NexusOperationExecutionCancellationInfo,
    json_name: "cancellationInfo"

  field :blocked_reason, 20, type: :string, json_name: "blockedReason"
  field :request_id, 21, type: :string, json_name: "requestId"
  field :operation_token, 22, type: :string, json_name: "operationToken"
  field :state_transition_count, 23, type: :int64, json_name: "stateTransitionCount"

  field :search_attributes, 24,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"

  field :nexus_header, 25,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.NexusOperationExecutionInfo.NexusHeaderEntry,
    json_name: "nexusHeader",
    map: true

  field :user_metadata, 26,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata,
    json_name: "userMetadata"

  field :links, 27, repeated: true, type: Temporal.Protos.Temporal.Api.Common.V1.Link
  field :identity, 28, type: :string
  field :state_size_bytes, 29, type: :int64, json_name: "stateSizeBytes"
end
