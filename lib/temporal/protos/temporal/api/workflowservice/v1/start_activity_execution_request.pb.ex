defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.StartActivityExecutionRequest do
  @moduledoc """
  Automatically generated module for StartActivityExecutionRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`activity_id`** | `string` | Identifier for this activity. Required. This identifier should be meaningful in the user's |
  | 5 | **`activity_type`** | `Temporal.Protos.Temporal.Api.Common.V1.ActivityType` | The type of the activity, a string that corresponds to a registered activity on a worker. |
  | 19 | **`completion_callbacks`** | `Temporal.Protos.Temporal.Api.Common.V1.Callback` | Callbacks to be called by the server when this activity reaches a terminal state. |
  | 16 | **`header`** | `Temporal.Protos.Temporal.Api.Common.V1.Header` | Header for context propagation and tracing purposes. |
  | 10 | **`heartbeat_timeout`** | `Google.Protobuf.Duration` | Maximum permitted time between successful worker heartbeats. |
  | 14 | **`id_conflict_policy`** | `Temporal.Protos.Temporal.Api.Enums.V1.ActivityIdConflictPolicy` | Defines how to resolve an activity id conflict with a *running* activity. |
  | 13 | **`id_reuse_policy`** | `Temporal.Protos.Temporal.Api.Enums.V1.ActivityIdReusePolicy` | Defines whether to allow re-using the activity id from a previously *closed* activity. |
  | 2 | **`identity`** | `string` | The identity of the client who initiated this request |
  | 12 | **`input`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Serialized arguments to the activity. These are passed as arguments to the activity function. |
  | 20 | **`links`** | `Temporal.Protos.Temporal.Api.Common.V1.Link` | Links to be associated with the activity. Callbacks may also have associated links; |
  | 1 | **`namespace`** | `string` |  |
  | 21 | **`on_conflict_options`** | `Temporal.Protos.Temporal.Api.Common.V1.OnConflictOptions` | Options for handling conflicts when using ACTIVITY_ID_CONFLICT_POLICY_USE_EXISTING. |
  | 18 | **`priority`** | `Temporal.Protos.Temporal.Api.Common.V1.Priority` | Priority metadata. |
  | 3 | **`request_id`** | `string` | A unique identifier for this start request. Typically UUIDv4. |
  | 11 | **`retry_policy`** | `Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy` | The retry policy for the activity. Will never exceed `schedule_to_close_timeout`. |
  | 7 | **`schedule_to_close_timeout`** | `Google.Protobuf.Duration` | Indicates how long the caller is willing to wait for an activity completion. Limits how long |
  | 8 | **`schedule_to_start_timeout`** | `Google.Protobuf.Duration` | Limits time an activity task can stay in a task queue before a worker picks it up. This |
  | 15 | **`search_attributes`** | `Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes` | Search attributes for indexing. |
  | 22 | **`start_delay`** | `Google.Protobuf.Duration` | Time to wait before dispatching the first activity task. This delay is not applied to retry attempts. |
  | 9 | **`start_to_close_timeout`** | `Google.Protobuf.Duration` | Maximum time an activity is allowed to execute after being picked up by a worker. This |
  | 6 | **`task_queue`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue` | Task queue to schedule this activity on. |
  | 17 | **`user_metadata`** | `Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata` | Metadata for use by user interfaces to display the fixed as-of-start summary and details of the activity. |

  ### Additional Notes

    * `activity_id` (`string`): Identifier for this activity. Required. This identifier should be meaningful in the user's
      own system. It must be unique among activities in the same namespace, subject to the rules
      imposed by id_reuse_policy and id_conflict_policy.
    * `completion_callbacks` (`Temporal.Protos.Temporal.Api.Common.V1.Callback`): Callbacks to be called by the server when this activity reaches a terminal state.
      Callback addresses must be whitelisted in the server's dynamic configuration.
    * `id_conflict_policy` (`Temporal.Protos.Temporal.Api.Enums.V1.ActivityIdConflictPolicy`): Defines how to resolve an activity id conflict with a *running* activity.
      The default policy is ACTIVITY_ID_CONFLICT_POLICY_FAIL.
    * `id_reuse_policy` (`Temporal.Protos.Temporal.Api.Enums.V1.ActivityIdReusePolicy`): Defines whether to allow re-using the activity id from a previously *closed* activity.
      The default policy is ACTIVITY_ID_REUSE_POLICY_ALLOW_DUPLICATE.
    * `links` (`Temporal.Protos.Temporal.Api.Common.V1.Link`): Links to be associated with the activity. Callbacks may also have associated links;
      links already included with a callback should not be duplicated here.
    * `schedule_to_close_timeout` (`Google.Protobuf.Duration`): Indicates how long the caller is willing to wait for an activity completion. Limits how long
      retries will be attempted. Either this or `start_to_close_timeout` must be specified.

      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "to" is used to indicate interval. --)
    * `schedule_to_start_timeout` (`Google.Protobuf.Duration`): Limits time an activity task can stay in a task queue before a worker picks it up. This
      timeout is always non retryable, as all a retry would achieve is to put it back into the same
      queue. Defaults to `schedule_to_close_timeout` if not specified.

      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "to" is used to indicate interval. --)
    * `start_to_close_timeout` (`Google.Protobuf.Duration`): Maximum time an activity is allowed to execute after being picked up by a worker. This
      timeout is always retryable. Either this or `schedule_to_close_timeout` must be
      specified.

      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "to" is used to indicate interval. --)

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :identity, 2, type: :string
  field :request_id, 3, type: :string, json_name: "requestId"
  field :activity_id, 4, type: :string, json_name: "activityId"

  field :activity_type, 5,
    type: Temporal.Protos.Temporal.Api.Common.V1.ActivityType,
    json_name: "activityType"

  field :task_queue, 6,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "taskQueue"

  field :schedule_to_close_timeout, 7,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToCloseTimeout"

  field :schedule_to_start_timeout, 8,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToStartTimeout"

  field :start_to_close_timeout, 9,
    type: Google.Protobuf.Duration,
    json_name: "startToCloseTimeout"

  field :heartbeat_timeout, 10, type: Google.Protobuf.Duration, json_name: "heartbeatTimeout"

  field :retry_policy, 11,
    type: Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy,
    json_name: "retryPolicy"

  field :input, 12, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads

  field :id_reuse_policy, 13,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ActivityIdReusePolicy,
    json_name: "idReusePolicy",
    enum: true

  field :id_conflict_policy, 14,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ActivityIdConflictPolicy,
    json_name: "idConflictPolicy",
    enum: true

  field :search_attributes, 15,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"

  field :header, 16, type: Temporal.Protos.Temporal.Api.Common.V1.Header

  field :user_metadata, 17,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata,
    json_name: "userMetadata"

  field :priority, 18, type: Temporal.Protos.Temporal.Api.Common.V1.Priority

  field :completion_callbacks, 19,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.Callback,
    json_name: "completionCallbacks"

  field :links, 20, repeated: true, type: Temporal.Protos.Temporal.Api.Common.V1.Link

  field :on_conflict_options, 21,
    type: Temporal.Protos.Temporal.Api.Common.V1.OnConflictOptions,
    json_name: "onConflictOptions"

  field :start_delay, 22, type: Google.Protobuf.Duration, json_name: "startDelay"
end
