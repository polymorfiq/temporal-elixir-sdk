defmodule Temporal.Protos.Temporal.Api.Workflow.V1.PendingNexusOperationInfo do
  @moduledoc """
  PendingNexusOperationInfo contains the state of a pending Nexus operation.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 8 | **`attempt`** | `int32` | The number of attempts made to deliver the start operation request. |
  | 14 | **`blocked_reason`** | `string` | If the state is BLOCKED, blocked reason provides additional information. |
  | 12 | **`cancellation_info`** | `Temporal.Protos.Temporal.Api.Workflow.V1.NexusOperationCancellationInfo` |  |
  | 1 | **`endpoint`** | `string` | Endpoint name. |
  | 9 | **`last_attempt_complete_time`** | `Google.Protobuf.Timestamp` | The time when the last attempt completed. |
  | 10 | **`last_attempt_failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | The last attempt's failure, if any. |
  | 11 | **`next_attempt_schedule_time`** | `Google.Protobuf.Timestamp` | The time when the next attempt is scheduled. |
  | 3 | **`operation`** | `string` | Operation name. |
  | 4 | **`operation_id`** | `string` | Operation ID. Only set for asynchronous operations after a successful StartOperation call. |
  | 15 | **`operation_token`** | `string` | Operation token. Only set for asynchronous operations after a successful StartOperation call. |
  | 5 | **`schedule_to_close_timeout`** | `Google.Protobuf.Duration` | Schedule-to-close timeout for this operation. |
  | 16 | **`schedule_to_start_timeout`** | `Google.Protobuf.Duration` | Schedule-to-start timeout for this operation. |
  | 13 | **`scheduled_event_id`** | `int64` | The event ID of the NexusOperationScheduled event. Can be used to correlate an operation in the |
  | 6 | **`scheduled_time`** | `Google.Protobuf.Timestamp` | The time when the operation was scheduled. |
  | 2 | **`service`** | `string` | Service name. |
  | 17 | **`start_to_close_timeout`** | `Google.Protobuf.Duration` | Start-to-close timeout for this operation. |
  | 7 | **`state`** | `Temporal.Protos.Temporal.Api.Enums.V1.PendingNexusOperationState` |  |

  ### Additional Notes

    * `attempt` (`int32`): The number of attempts made to deliver the start operation request.
      This number is approximate, it is incremented when a task is added to the history queue.
      In practice, there could be more attempts if a task is executed but fails to commit, or less attempts if a task
      was never executed.
    * `endpoint` (`string`): Endpoint name.
      Resolved to a URL via the cluster's endpoint registry.
    * `operation_id` (`string`): Operation ID. Only set for asynchronous operations after a successful StartOperation call.

      Deprecated. Renamed to operation_token.
    * `schedule_to_close_timeout` (`Google.Protobuf.Duration`): Schedule-to-close timeout for this operation.
      This is the only timeout settable by a workflow.
      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "to" is used to indicate interval. --)
    * `schedule_to_start_timeout` (`Google.Protobuf.Duration`): Schedule-to-start timeout for this operation.
      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "to" is used to indicate interval. --)
    * `scheduled_event_id` (`int64`): The event ID of the NexusOperationScheduled event. Can be used to correlate an operation in the
      DescribeWorkflowExecution response with workflow history.
    * `start_to_close_timeout` (`Google.Protobuf.Duration`): Start-to-close timeout for this operation.
      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "to" is used to indicate interval. --)

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :endpoint, 1, type: :string
  field :service, 2, type: :string
  field :operation, 3, type: :string
  field :operation_id, 4, type: :string, json_name: "operationId", deprecated: true

  field :schedule_to_close_timeout, 5,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToCloseTimeout"

  field :scheduled_time, 6, type: Google.Protobuf.Timestamp, json_name: "scheduledTime"

  field :state, 7,
    type: Temporal.Protos.Temporal.Api.Enums.V1.PendingNexusOperationState,
    enum: true

  field :attempt, 8, type: :int32

  field :last_attempt_complete_time, 9,
    type: Google.Protobuf.Timestamp,
    json_name: "lastAttemptCompleteTime"

  field :last_attempt_failure, 10,
    type: Temporal.Protos.Temporal.Api.Failure.V1.Failure,
    json_name: "lastAttemptFailure"

  field :next_attempt_schedule_time, 11,
    type: Google.Protobuf.Timestamp,
    json_name: "nextAttemptScheduleTime"

  field :cancellation_info, 12,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.NexusOperationCancellationInfo,
    json_name: "cancellationInfo"

  field :scheduled_event_id, 13, type: :int64, json_name: "scheduledEventId"
  field :blocked_reason, 14, type: :string, json_name: "blockedReason"
  field :operation_token, 15, type: :string, json_name: "operationToken"

  field :schedule_to_start_timeout, 16,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToStartTimeout"

  field :start_to_close_timeout, 17,
    type: Google.Protobuf.Duration,
    json_name: "startToCloseTimeout"
end
