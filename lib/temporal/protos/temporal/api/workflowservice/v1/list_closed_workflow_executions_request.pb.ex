defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListClosedWorkflowExecutionsRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:filters, 0)

  field(:namespace, 1, type: :string)
  field(:maximum_page_size, 2, type: :int32, json_name: "maximumPageSize")
  field(:next_page_token, 3, type: :bytes, json_name: "nextPageToken")

  field(:start_time_filter, 4,
    type: Temporal.Protos.Temporal.Api.Filter.V1.StartTimeFilter,
    json_name: "startTimeFilter"
  )

  field(:execution_filter, 5,
    type: Temporal.Protos.Temporal.Api.Filter.V1.WorkflowExecutionFilter,
    json_name: "executionFilter",
    oneof: 0
  )

  field(:type_filter, 6,
    type: Temporal.Protos.Temporal.Api.Filter.V1.WorkflowTypeFilter,
    json_name: "typeFilter",
    oneof: 0
  )

  field(:status_filter, 7,
    type: Temporal.Protos.Temporal.Api.Filter.V1.StatusFilter,
    json_name: "statusFilter",
    oneof: 0
  )
end
