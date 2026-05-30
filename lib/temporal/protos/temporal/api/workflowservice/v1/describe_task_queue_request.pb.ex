defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeTaskQueueRequest do
  @moduledoc """
  (-- api-linter: core::0203::optional=disabled
  aip.dev/not-precedent: field_behavior annotation not available in our gogo fork --)

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`api_mode`** | `Temporal.Protos.Temporal.Api.Enums.V1.DescribeTaskQueueMode` | Deprecated. ENHANCED mode is also being deprecated. |
  | 4 | **`include_task_queue_status`** | `bool` | Deprecated, use `report_stats` instead. |
  | 1 | **`namespace`** | `string` |  |
  | 11 | **`report_config`** | `bool` | Report Task Queue Config |
  | 9 | **`report_pollers`** | `bool` | Deprecated (as part of the ENHANCED mode deprecation). |
  | 8 | **`report_stats`** | `bool` | Report stats for the requested task queue type(s). |
  | 10 | **`report_task_reachability`** | `bool` | Deprecated (as part of the ENHANCED mode deprecation). |
  | 2 | **`task_queue`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue` | Sticky queues are not supported in deprecated ENHANCED mode. |
  | 3 | **`task_queue_type`** | `Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType` | If unspecified (TASK_QUEUE_TYPE_UNSPECIFIED), then default value (TASK_QUEUE_TYPE_WORKFLOW) will be used. |
  | 7 | **`task_queue_types`** | `Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType` | Deprecated (as part of the ENHANCED mode deprecation). |
  | 6 | **`versions`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueVersionSelection` | Deprecated (as part of the ENHANCED mode deprecation). |

  ### Additional Notes

    * `api_mode` (`Temporal.Protos.Temporal.Api.Enums.V1.DescribeTaskQueueMode`): Deprecated. ENHANCED mode is also being deprecated.
      Select the API mode to use for this request: DEFAULT mode (if unset) or ENHANCED mode.
      Consult the documentation for each field to understand which mode it is supported in.
    * `include_task_queue_status` (`bool`): Deprecated, use `report_stats` instead.
      If true, the task queue status will be included in the response.
    * `report_pollers` (`bool`): Deprecated (as part of the ENHANCED mode deprecation).
      Report list of pollers for requested task queue types and versions.
    * `report_task_reachability` (`bool`): Deprecated (as part of the ENHANCED mode deprecation).
      Report task reachability for the requested versions and all task types (task reachability is not reported
      per task type).
    * `task_queue_type` (`Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType`): If unspecified (TASK_QUEUE_TYPE_UNSPECIFIED), then default value (TASK_QUEUE_TYPE_WORKFLOW) will be used.
      Only supported in default mode (use `task_queue_types` in ENHANCED mode instead).
    * `task_queue_types` (`Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType`): Deprecated (as part of the ENHANCED mode deprecation).
      Task queue types to report info about. If not specified, all types are considered.
    * `versions` (`Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueVersionSelection`): Deprecated (as part of the ENHANCED mode deprecation).
      Optional. If not provided, the result for the default Build ID will be returned. The default Build ID is the one
      mentioned in the first unconditional Assignment Rule. If there is no default Build ID, the result for the
      unversioned queue will be returned.
      (-- api-linter: core::0140::prepositions --)

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string

  field :task_queue, 2,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "taskQueue"

  field :task_queue_type, 3,
    type: Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType,
    json_name: "taskQueueType",
    enum: true

  field :report_stats, 8, type: :bool, json_name: "reportStats"
  field :report_config, 11, type: :bool, json_name: "reportConfig"

  field :include_task_queue_status, 4,
    type: :bool,
    json_name: "includeTaskQueueStatus",
    deprecated: true

  field :api_mode, 5,
    type: Temporal.Protos.Temporal.Api.Enums.V1.DescribeTaskQueueMode,
    json_name: "apiMode",
    enum: true,
    deprecated: true

  field :versions, 6,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueVersionSelection,
    deprecated: true

  field :task_queue_types, 7,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType,
    json_name: "taskQueueTypes",
    enum: true,
    deprecated: true

  field :report_pollers, 9, type: :bool, json_name: "reportPollers", deprecated: true

  field :report_task_reachability, 10,
    type: :bool,
    json_name: "reportTaskReachability",
    deprecated: true
end
