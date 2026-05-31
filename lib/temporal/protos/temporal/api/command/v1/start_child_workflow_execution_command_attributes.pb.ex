defmodule Temporal.Protos.Temporal.Api.Command.V1.StartChildWorkflowExecutionCommandAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string, deprecated: true)
  field(:workflow_id, 2, type: :string, json_name: "workflowId")

  field(:workflow_type, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowType,
    json_name: "workflowType"
  )

  field(:task_queue, 4,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "taskQueue"
  )

  field(:input, 5, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)

  field(:workflow_execution_timeout, 6,
    type: Google.Protobuf.Duration,
    json_name: "workflowExecutionTimeout"
  )

  field(:workflow_run_timeout, 7, type: Google.Protobuf.Duration, json_name: "workflowRunTimeout")

  field(:workflow_task_timeout, 8,
    type: Google.Protobuf.Duration,
    json_name: "workflowTaskTimeout"
  )

  field(:parent_close_policy, 9,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ParentClosePolicy,
    json_name: "parentClosePolicy",
    enum: true
  )

  field(:control, 10, type: :string)

  field(:workflow_id_reuse_policy, 11,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkflowIdReusePolicy,
    json_name: "workflowIdReusePolicy",
    enum: true
  )

  field(:retry_policy, 12,
    type: Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy,
    json_name: "retryPolicy"
  )

  field(:cron_schedule, 13, type: :string, json_name: "cronSchedule")
  field(:header, 14, type: Temporal.Protos.Temporal.Api.Common.V1.Header)
  field(:memo, 15, type: Temporal.Protos.Temporal.Api.Common.V1.Memo)

  field(:search_attributes, 16,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"
  )

  field(:inherit_build_id, 17, type: :bool, json_name: "inheritBuildId", deprecated: true)
  field(:priority, 18, type: Temporal.Protos.Temporal.Api.Common.V1.Priority)
end
