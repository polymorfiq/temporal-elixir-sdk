defmodule Temporal.Protos.Temporal.Api.History.V1.StartChildWorkflowExecutionInitiatedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:namespace_id, 18, type: :string, json_name: "namespaceId")
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

  field(:control, 10, type: :string, deprecated: true)

  field(:workflow_task_completed_event_id, 11,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"
  )

  field(:workflow_id_reuse_policy, 12,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkflowIdReusePolicy,
    json_name: "workflowIdReusePolicy",
    enum: true
  )

  field(:retry_policy, 13,
    type: Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy,
    json_name: "retryPolicy"
  )

  field(:cron_schedule, 14, type: :string, json_name: "cronSchedule")
  field(:header, 15, type: Temporal.Protos.Temporal.Api.Common.V1.Header)
  field(:memo, 16, type: Temporal.Protos.Temporal.Api.Common.V1.Memo)

  field(:search_attributes, 17,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"
  )

  field(:inherit_build_id, 19, type: :bool, json_name: "inheritBuildId", deprecated: true)
  field(:priority, 20, type: Temporal.Protos.Temporal.Api.Common.V1.Priority)

  field(:time_skipping_config, 21,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.TimeSkippingConfig,
    json_name: "timeSkippingConfig"
  )

  field(:initial_skipped_duration, 30,
    type: Google.Protobuf.Duration,
    json_name: "initialSkippedDuration"
  )
end
