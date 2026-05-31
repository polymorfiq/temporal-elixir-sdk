defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondQueryTaskCompletedRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:task_token, 1, type: :bytes, json_name: "taskToken")

  field(:completed_type, 2,
    type: Temporal.Protos.Temporal.Api.Enums.V1.QueryResultType,
    json_name: "completedType",
    enum: true
  )

  field(:query_result, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payloads,
    json_name: "queryResult"
  )

  field(:error_message, 4, type: :string, json_name: "errorMessage")
  field(:namespace, 6, type: :string)
  field(:failure, 7, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure)

  field(:cause, 8,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkflowTaskFailedCause,
    enum: true
  )

  field(:poller_group_id, 9, type: :string, json_name: "pollerGroupId")
end
