defmodule Temporal.Protos.Temporal.Api.Command.V1.ContinueAsNewWorkflowExecutionCommandAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:workflow_type, 1,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowType,
    json_name: "workflowType"
  )

  field(:task_queue, 2,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "taskQueue"
  )

  field(:input, 3, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)
  field(:workflow_run_timeout, 4, type: Google.Protobuf.Duration, json_name: "workflowRunTimeout")

  field(:workflow_task_timeout, 5,
    type: Google.Protobuf.Duration,
    json_name: "workflowTaskTimeout"
  )

  field(:backoff_start_interval, 6,
    type: Google.Protobuf.Duration,
    json_name: "backoffStartInterval"
  )

  field(:retry_policy, 7,
    type: Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy,
    json_name: "retryPolicy"
  )

  field(:initiator, 8,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ContinueAsNewInitiator,
    enum: true
  )

  field(:failure, 9, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure)

  field(:last_completion_result, 10,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payloads,
    json_name: "lastCompletionResult"
  )

  field(:cron_schedule, 11, type: :string, json_name: "cronSchedule")
  field(:header, 12, type: Temporal.Protos.Temporal.Api.Common.V1.Header)
  field(:memo, 13, type: Temporal.Protos.Temporal.Api.Common.V1.Memo)

  field(:search_attributes, 14,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"
  )

  field(:inherit_build_id, 15, type: :bool, json_name: "inheritBuildId", deprecated: true)

  field(:initial_versioning_behavior, 16,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ContinueAsNewVersioningBehavior,
    json_name: "initialVersioningBehavior",
    enum: true
  )
end
