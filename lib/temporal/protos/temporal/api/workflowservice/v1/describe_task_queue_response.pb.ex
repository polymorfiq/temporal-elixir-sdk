defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeTaskQueueResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:pollers, 1, repeated: true, type: Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerInfo)
  field(:stats, 5, type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueStats)

  field(:stats_by_priority_key, 8,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeTaskQueueResponse.StatsByPriorityKeyEntry,
    json_name: "statsByPriorityKey",
    map: true
  )

  field(:versioning_info, 4,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueVersioningInfo,
    json_name: "versioningInfo"
  )

  field(:config, 6, type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueConfig)

  field(:effective_rate_limit, 7,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeTaskQueueResponse.EffectiveRateLimit,
    json_name: "effectiveRateLimit"
  )

  field(:task_queue_status, 2,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueStatus,
    json_name: "taskQueueStatus",
    deprecated: true
  )

  field(:versions_info, 3,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeTaskQueueResponse.VersionsInfoEntry,
    json_name: "versionsInfo",
    map: true,
    deprecated: true
  )
end
