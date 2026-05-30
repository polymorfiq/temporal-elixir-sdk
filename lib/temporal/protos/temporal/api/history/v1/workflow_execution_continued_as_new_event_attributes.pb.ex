defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionContinuedAsNewEventAttributes do
  @moduledoc """
  Automatically generated module for WorkflowExecutionContinuedAsNewEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 8 | **`backoff_start_interval`** | `Google.Protobuf.Duration` | How long the server will wait before scheduling the first workflow task for the new run. |
  | 10 | **`failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | Deprecated. If a workflow's retry policy would cause a new run to start when the current one |
  | 12 | **`header`** | `Temporal.Protos.Temporal.Api.Common.V1.Header` |  |
  | 15 | **`inherit_build_id`** | `bool` | If this is set, the new execution inherits the Build ID of the current execution. Otherwise, |
  | 16 | **`initial_versioning_behavior`** | `Temporal.Protos.Temporal.Api.Enums.V1.ContinueAsNewVersioningBehavior` | Experimental. Optionally decide the versioning behavior that the first task of the new run should use. |
  | 9 | **`initiator`** | `Temporal.Protos.Temporal.Api.Enums.V1.ContinueAsNewInitiator` |  |
  | 4 | **`input`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` |  |
  | 11 | **`last_completion_result`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | The result from the most recent completed run of this workflow. The SDK surfaces this to the |
  | 13 | **`memo`** | `Temporal.Protos.Temporal.Api.Common.V1.Memo` |  |
  | 1 | **`new_execution_run_id`** | `string` | The run ID of the new workflow started by this continue-as-new |
  | 14 | **`search_attributes`** | `Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes` |  |
  | 3 | **`task_queue`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue` |  |
  | 5 | **`workflow_run_timeout`** | `Google.Protobuf.Duration` | Timeout of a single workflow run. |
  | 7 | **`workflow_task_completed_event_id`** | `int64` | The `WORKFLOW_TASK_COMPLETED` event which this command was reported with |
  | 6 | **`workflow_task_timeout`** | `Google.Protobuf.Duration` | Timeout of a single workflow task. |
  | 2 | **`workflow_type`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowType` |  |

  ### Additional Notes

    * `backoff_start_interval` (`Google.Protobuf.Duration`): How long the server will wait before scheduling the first workflow task for the new run.
      Used for cron, retry, and other continue-as-new cases that server may enforce some minimal
      delay between new runs for system protection purpose.
    * `failure` (`Temporal.Protos.Temporal.Api.Failure.V1.Failure`): Deprecated. If a workflow's retry policy would cause a new run to start when the current one
      has failed, this field would be populated with that failure. Now (when supported by server
      and sdk) the final event will be `WORKFLOW_EXECUTION_FAILED` with `new_execution_run_id` set.
    * `inherit_build_id` (`bool`): If this is set, the new execution inherits the Build ID of the current execution. Otherwise,
      the assignment rules will be used to independently assign a Build ID to the new execution.
      Deprecated. Only considered for versioning v0.2.
    * `initial_versioning_behavior` (`Temporal.Protos.Temporal.Api.Enums.V1.ContinueAsNewVersioningBehavior`): Experimental. Optionally decide the versioning behavior that the first task of the new run should use.
      For example, choose to AutoUpgrade on continue-as-new instead of inheriting the pinned version
      of the previous run.
    * `last_completion_result` (`Temporal.Protos.Temporal.Api.Common.V1.Payloads`): The result from the most recent completed run of this workflow. The SDK surfaces this to the
      new run via APIs such as `GetLastCompletionResult`.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :new_execution_run_id, 1, type: :string, json_name: "newExecutionRunId"

  field :workflow_type, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowType,
    json_name: "workflowType"

  field :task_queue, 3,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "taskQueue"

  field :input, 4, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
  field :workflow_run_timeout, 5, type: Google.Protobuf.Duration, json_name: "workflowRunTimeout"

  field :workflow_task_timeout, 6,
    type: Google.Protobuf.Duration,
    json_name: "workflowTaskTimeout"

  field :workflow_task_completed_event_id, 7,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"

  field :backoff_start_interval, 8,
    type: Google.Protobuf.Duration,
    json_name: "backoffStartInterval"

  field :initiator, 9,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ContinueAsNewInitiator,
    enum: true

  field :failure, 10, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure, deprecated: true

  field :last_completion_result, 11,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payloads,
    json_name: "lastCompletionResult"

  field :header, 12, type: Temporal.Protos.Temporal.Api.Common.V1.Header
  field :memo, 13, type: Temporal.Protos.Temporal.Api.Common.V1.Memo

  field :search_attributes, 14,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"

  field :inherit_build_id, 15, type: :bool, json_name: "inheritBuildId", deprecated: true

  field :initial_versioning_behavior, 16,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ContinueAsNewVersioningBehavior,
    json_name: "initialVersioningBehavior",
    enum: true
end
