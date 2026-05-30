defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowTaskStartedEventAttributes do
  @moduledoc """
  Automatically generated module for WorkflowTaskStartedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 7 | **`build_id_redirect_counter`** | `int64` | Used by server internally to properly reapply build ID redirects to an execution |
  | 5 | **`history_size_bytes`** | `int64` | Total history size in bytes, which the workflow might use to decide when to |
  | 2 | **`identity`** | `string` | Identity of the worker who picked up this task |
  | 3 | **`request_id`** | `string` | This field is populated from the RecordWorkflowTaskStartedRequest. Matching service would |
  | 1 | **`scheduled_event_id`** | `int64` | The id of the `WORKFLOW_TASK_SCHEDULED` event this task corresponds to |
  | 4 | **`suggest_continue_as_new`** | `bool` | True if this workflow should continue-as-new soon. See `suggest_continue_as_new_reasons` for why. |
  | 8 | **`suggest_continue_as_new_reasons`** | `Temporal.Protos.Temporal.Api.Enums.V1.SuggestContinueAsNewReason` | The reason(s) that suggest_continue_as_new is true, if it is. |
  | 9 | **`target_worker_deployment_version_changed`** | `bool` | True if Workflow's Target Worker Deployment Version is different from its Pinned Version and |
  | 6 | **`worker_version`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp` | Version info of the worker to whom this task was dispatched. |

  ### Additional Notes

    * `build_id_redirect_counter` (`int64`): Used by server internally to properly reapply build ID redirects to an execution
      when rebuilding it from events.
      Deprecated. This field should be cleaned up when versioning-2 API is removed. [cleanup-experimental-wv]
    * `history_size_bytes` (`int64`): Total history size in bytes, which the workflow might use to decide when to
      continue-as-new regardless of the suggestion. Note that history event count is
      just the event id of this event, so we don't include it explicitly here.
    * `request_id` (`string`): This field is populated from the RecordWorkflowTaskStartedRequest. Matching service would
      set the request_id on the RecordWorkflowTaskStartedRequest to a new UUID. This is useful
      in case a RecordWorkflowTaskStarted call succeed but matching doesn't get that response,
      so matching could retry and history service would return success if the request_id matches.
      In that case, matching will continue to deliver the task to worker. Without this field, history
      service would return AlreadyStarted error, and matching would drop the task.
    * `suggest_continue_as_new_reasons` (`Temporal.Protos.Temporal.Api.Enums.V1.SuggestContinueAsNewReason`): The reason(s) that suggest_continue_as_new is true, if it is.
      Unset if suggest_continue_as_new is false.
    * `target_worker_deployment_version_changed` (`bool`): True if Workflow's Target Worker Deployment Version is different from its Pinned Version and
      the workflow is Pinned.
      Experimental.
    * `worker_version` (`Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp`): Version info of the worker to whom this task was dispatched.
      Deprecated. This field should be cleaned up when versioning-2 API is removed. [cleanup-experimental-wv]

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId"
  field :identity, 2, type: :string
  field :request_id, 3, type: :string, json_name: "requestId"
  field :suggest_continue_as_new, 4, type: :bool, json_name: "suggestContinueAsNew"

  field :suggest_continue_as_new_reasons, 8,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Enums.V1.SuggestContinueAsNewReason,
    json_name: "suggestContinueAsNewReasons",
    enum: true

  field :target_worker_deployment_version_changed, 9,
    type: :bool,
    json_name: "targetWorkerDeploymentVersionChanged"

  field :history_size_bytes, 5, type: :int64, json_name: "historySizeBytes"

  field :worker_version, 6,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "workerVersion",
    deprecated: true

  field :build_id_redirect_counter, 7,
    type: :int64,
    json_name: "buildIdRedirectCounter",
    deprecated: true
end
