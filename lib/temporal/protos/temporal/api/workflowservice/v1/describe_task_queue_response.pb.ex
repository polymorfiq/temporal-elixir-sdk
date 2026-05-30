defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeTaskQueueResponse do
  @moduledoc """
  Automatically generated module for DescribeTaskQueueResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 6 | **`config`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueConfig` | Only populated if report_task_queue_config is set to true. |
  | 7 | **`effective_rate_limit`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeTaskQueueResponse.EffectiveRateLimit` |  |
  | 1 | **`pollers`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerInfo` |  |
  | 5 | **`stats`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueStats` | Statistics for the task queue. |
  | 8 | **`stats_by_priority_key`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeTaskQueueResponse.StatsByPriorityKeyEntry` | Task queue stats breakdown by priority key. Only contains actively used priority keys. |
  | 2 | **`task_queue_status`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueStatus` | Deprecated. |
  | 4 | **`versioning_info`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueVersioningInfo` | Specifies which Worker Deployment Version(s) Server routes this Task Queue's tasks to. |
  | 3 | **`versions_info`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeTaskQueueResponse.VersionsInfoEntry` | Deprecated. |

  ### Additional Notes

    * `stats` (`Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueStats`): Statistics for the task queue.
      Only set if `report_stats` is set on the request.
    * `stats_by_priority_key` (`Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeTaskQueueResponse.StatsByPriorityKeyEntry`): Task queue stats breakdown by priority key. Only contains actively used priority keys.
      Only set if `report_stats` is set on the request.
      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "by" is used to clarify the keys and values. --)
    * `task_queue_status` (`Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueStatus`): Deprecated.
      Status of the task queue. Only populated when `include_task_queue_status` is set to true in the request.
    * `versioning_info` (`Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueVersioningInfo`): Specifies which Worker Deployment Version(s) Server routes this Task Queue's tasks to.
      When not present, it means the tasks are routed to Unversioned workers (workers with
      UNVERSIONED or unspecified WorkerVersioningMode.)
      Task Queue Versioning info is updated indirectly by calling SetWorkerDeploymentCurrentVersion
      and SetWorkerDeploymentRampingVersion on Worker Deployments.
      Note: This information is not relevant to Pinned workflow executions and their activities as
      they are always routed to their Pinned Deployment Version. However, new workflow executions
      are typically not Pinned until they complete their first task (unless they are started with
      a Pinned VersioningOverride or are Child Workflows of a Pinned parent).
    * `versions_info` (`Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeTaskQueueResponse.VersionsInfoEntry`): Deprecated.
      Only returned in ENHANCED mode.
      This map contains Task Queue information for each Build ID. Empty string as key value means unversioned.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :pollers, 1, repeated: true, type: Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerInfo
  field :stats, 5, type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueStats

  field :stats_by_priority_key, 8,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeTaskQueueResponse.StatsByPriorityKeyEntry,
    json_name: "statsByPriorityKey",
    map: true

  field :versioning_info, 4,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueVersioningInfo,
    json_name: "versioningInfo"

  field :config, 6, type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueConfig

  field :effective_rate_limit, 7,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeTaskQueueResponse.EffectiveRateLimit,
    json_name: "effectiveRateLimit"

  field :task_queue_status, 2,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueStatus,
    json_name: "taskQueueStatus",
    deprecated: true

  field :versions_info, 3,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeTaskQueueResponse.VersionsInfoEntry,
    json_name: "versionsInfo",
    map: true,
    deprecated: true
end
