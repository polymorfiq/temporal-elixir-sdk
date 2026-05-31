defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeTaskQueueRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)

  field(:task_queue, 2,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "taskQueue"
  )

  field(:task_queue_type, 3,
    type: Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType,
    json_name: "taskQueueType",
    enum: true
  )

  field(:report_stats, 8, type: :bool, json_name: "reportStats")
  field(:report_config, 11, type: :bool, json_name: "reportConfig")

  field(:include_task_queue_status, 4,
    type: :bool,
    json_name: "includeTaskQueueStatus",
    deprecated: true
  )

  field(:api_mode, 5,
    type: Temporal.Protos.Temporal.Api.Enums.V1.DescribeTaskQueueMode,
    json_name: "apiMode",
    enum: true,
    deprecated: true
  )

  field(:versions, 6,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueVersionSelection,
    deprecated: true
  )

  field(:task_queue_types, 7,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType,
    json_name: "taskQueueTypes",
    enum: true,
    deprecated: true
  )

  field(:report_pollers, 9, type: :bool, json_name: "reportPollers", deprecated: true)

  field(:report_task_reachability, 10,
    type: :bool,
    json_name: "reportTaskReachability",
    deprecated: true
  )
end
