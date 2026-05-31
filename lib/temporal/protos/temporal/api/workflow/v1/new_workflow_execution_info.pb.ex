defmodule Temporal.Protos.Temporal.Api.Workflow.V1.NewWorkflowExecutionInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:workflow_id, 1, type: :string, json_name: "workflowId")

  field(:workflow_type, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowType,
    json_name: "workflowType"
  )

  field(:task_queue, 3,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "taskQueue"
  )

  field(:input, 4, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)

  field(:workflow_execution_timeout, 5,
    type: Google.Protobuf.Duration,
    json_name: "workflowExecutionTimeout"
  )

  field(:workflow_run_timeout, 6, type: Google.Protobuf.Duration, json_name: "workflowRunTimeout")

  field(:workflow_task_timeout, 7,
    type: Google.Protobuf.Duration,
    json_name: "workflowTaskTimeout"
  )

  field(:workflow_id_reuse_policy, 8,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkflowIdReusePolicy,
    json_name: "workflowIdReusePolicy",
    enum: true
  )

  field(:retry_policy, 9,
    type: Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy,
    json_name: "retryPolicy"
  )

  field(:cron_schedule, 10, type: :string, json_name: "cronSchedule")
  field(:memo, 11, type: Temporal.Protos.Temporal.Api.Common.V1.Memo)

  field(:search_attributes, 12,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"
  )

  field(:header, 13, type: Temporal.Protos.Temporal.Api.Common.V1.Header)

  field(:user_metadata, 14,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata,
    json_name: "userMetadata"
  )

  field(:versioning_override, 15,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride,
    json_name: "versioningOverride"
  )

  field(:priority, 16, type: Temporal.Protos.Temporal.Api.Common.V1.Priority)
end
