defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.StartActivityExecutionRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:identity, 2, type: :string)
  field(:request_id, 3, type: :string, json_name: "requestId")
  field(:activity_id, 4, type: :string, json_name: "activityId")

  field(:activity_type, 5,
    type: Temporal.Protos.Temporal.Api.Common.V1.ActivityType,
    json_name: "activityType"
  )

  field(:task_queue, 6,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "taskQueue"
  )

  field(:schedule_to_close_timeout, 7,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToCloseTimeout"
  )

  field(:schedule_to_start_timeout, 8,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToStartTimeout"
  )

  field(:start_to_close_timeout, 9,
    type: Google.Protobuf.Duration,
    json_name: "startToCloseTimeout"
  )

  field(:heartbeat_timeout, 10, type: Google.Protobuf.Duration, json_name: "heartbeatTimeout")

  field(:retry_policy, 11,
    type: Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy,
    json_name: "retryPolicy"
  )

  field(:input, 12, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)

  field(:id_reuse_policy, 13,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ActivityIdReusePolicy,
    json_name: "idReusePolicy",
    enum: true
  )

  field(:id_conflict_policy, 14,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ActivityIdConflictPolicy,
    json_name: "idConflictPolicy",
    enum: true
  )

  field(:search_attributes, 15,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"
  )

  field(:header, 16, type: Temporal.Protos.Temporal.Api.Common.V1.Header)

  field(:user_metadata, 17,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata,
    json_name: "userMetadata"
  )

  field(:priority, 18, type: Temporal.Protos.Temporal.Api.Common.V1.Priority)

  field(:completion_callbacks, 19,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.Callback,
    json_name: "completionCallbacks"
  )

  field(:links, 20, repeated: true, type: Temporal.Protos.Temporal.Api.Common.V1.Link)

  field(:on_conflict_options, 21,
    type: Temporal.Protos.Temporal.Api.Common.V1.OnConflictOptions,
    json_name: "onConflictOptions"
  )

  field(:start_delay, 22, type: Google.Protobuf.Duration, json_name: "startDelay")
end
