defmodule Temporal.Protos.Temporal.Api.Command.V1.ContinueAsNewWorkflowExecutionCommandAttributes do
  @moduledoc """
  Automatically generated module for ContinueAsNewWorkflowExecutionCommandAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 6 | **`backoff_start_interval`** | `Google.Protobuf.Duration` | How long the workflow start will be delayed - not really a "backoff" in the traditional sense. |
  | 11 | **`cron_schedule`** | `string` | Should be removed. Not necessarily unused but unclear and not exposed by SDKs. |
  | 9 | **`failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | Should be removed |
  | 12 | **`header`** | `Temporal.Protos.Temporal.Api.Common.V1.Header` |  |
  | 15 | **`inherit_build_id`** | `bool` | If this is set, the new execution inherits the Build ID of the current execution. Otherwise, |
  | 16 | **`initial_versioning_behavior`** | `Temporal.Protos.Temporal.Api.Enums.V1.ContinueAsNewVersioningBehavior` | Experimental. Optionally decide the versioning behavior that the first task of the new run should use. |
  | 8 | **`initiator`** | `Temporal.Protos.Temporal.Api.Enums.V1.ContinueAsNewInitiator` | Should be removed |
  | 3 | **`input`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` |  |
  | 10 | **`last_completion_result`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Should be removed |
  | 13 | **`memo`** | `Temporal.Protos.Temporal.Api.Common.V1.Memo` |  |
  | 7 | **`retry_policy`** | `Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy` |  |
  | 14 | **`search_attributes`** | `Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes` |  |
  | 2 | **`task_queue`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue` |  |
  | 4 | **`workflow_run_timeout`** | `Google.Protobuf.Duration` | Timeout of a single workflow run. |
  | 5 | **`workflow_task_timeout`** | `Google.Protobuf.Duration` | Timeout of a single workflow task. |
  | 1 | **`workflow_type`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowType` |  |

  ### Additional Notes

    * `inherit_build_id` (`bool`): If this is set, the new execution inherits the Build ID of the current execution. Otherwise,
      the assignment rules will be used to independently assign a Build ID to the new execution.
      Deprecated. Only considered for versioning v0.2.
    * `initial_versioning_behavior` (`Temporal.Protos.Temporal.Api.Enums.V1.ContinueAsNewVersioningBehavior`): Experimental. Optionally decide the versioning behavior that the first task of the new run should use.
      For example, choose to AutoUpgrade on continue-as-new instead of inheriting the pinned version
      of the previous run.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :workflow_type, 1,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowType,
    json_name: "workflowType"

  field :task_queue, 2,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "taskQueue"

  field :input, 3, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
  field :workflow_run_timeout, 4, type: Google.Protobuf.Duration, json_name: "workflowRunTimeout"

  field :workflow_task_timeout, 5,
    type: Google.Protobuf.Duration,
    json_name: "workflowTaskTimeout"

  field :backoff_start_interval, 6,
    type: Google.Protobuf.Duration,
    json_name: "backoffStartInterval"

  field :retry_policy, 7,
    type: Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy,
    json_name: "retryPolicy"

  field :initiator, 8,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ContinueAsNewInitiator,
    enum: true

  field :failure, 9, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure

  field :last_completion_result, 10,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payloads,
    json_name: "lastCompletionResult"

  field :cron_schedule, 11, type: :string, json_name: "cronSchedule"
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
