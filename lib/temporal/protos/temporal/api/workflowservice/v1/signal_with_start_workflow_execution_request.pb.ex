defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.SignalWithStartWorkflowExecutionRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
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

  field(:identity, 9, type: :string)
  field(:request_id, 10, type: :string, json_name: "requestId")

  field(:workflow_id_reuse_policy, 11,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkflowIdReusePolicy,
    json_name: "workflowIdReusePolicy",
    enum: true
  )

  field(:workflow_id_conflict_policy, 22,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkflowIdConflictPolicy,
    json_name: "workflowIdConflictPolicy",
    enum: true
  )

  field(:signal_name, 12, type: :string, json_name: "signalName")

  field(:signal_input, 13,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payloads,
    json_name: "signalInput"
  )

  field(:control, 14, type: :string, deprecated: true)

  field(:retry_policy, 15,
    type: Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy,
    json_name: "retryPolicy"
  )

  field(:cron_schedule, 16, type: :string, json_name: "cronSchedule")
  field(:memo, 17, type: Temporal.Protos.Temporal.Api.Common.V1.Memo)

  field(:search_attributes, 18,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"
  )

  field(:header, 19, type: Temporal.Protos.Temporal.Api.Common.V1.Header)

  field(:workflow_start_delay, 20,
    type: Google.Protobuf.Duration,
    json_name: "workflowStartDelay"
  )

  field(:user_metadata, 23,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata,
    json_name: "userMetadata"
  )

  field(:links, 24, repeated: true, type: Temporal.Protos.Temporal.Api.Common.V1.Link)

  field(:versioning_override, 25,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride,
    json_name: "versioningOverride"
  )

  field(:priority, 26, type: Temporal.Protos.Temporal.Api.Common.V1.Priority)

  field(:time_skipping_config, 27,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.TimeSkippingConfig,
    json_name: "timeSkippingConfig"
  )
end
