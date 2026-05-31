defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionContinuedAsNewEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:new_execution_run_id, 1, type: :string, json_name: "newExecutionRunId")

  field(:workflow_type, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowType,
    json_name: "workflowType"
  )

  field(:task_queue, 3,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "taskQueue"
  )

  field(:input, 4, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)
  field(:workflow_run_timeout, 5, type: Google.Protobuf.Duration, json_name: "workflowRunTimeout")

  field(:workflow_task_timeout, 6,
    type: Google.Protobuf.Duration,
    json_name: "workflowTaskTimeout"
  )

  field(:workflow_task_completed_event_id, 7,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"
  )

  field(:backoff_start_interval, 8,
    type: Google.Protobuf.Duration,
    json_name: "backoffStartInterval"
  )

  field(:initiator, 9,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ContinueAsNewInitiator,
    enum: true
  )

  field(:failure, 10, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure, deprecated: true)

  field(:last_completion_result, 11,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payloads,
    json_name: "lastCompletionResult"
  )

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
