defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.GetWorkflowExecutionHistoryRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:execution, 2, type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution)
  field(:maximum_page_size, 3, type: :int32, json_name: "maximumPageSize")
  field(:next_page_token, 4, type: :bytes, json_name: "nextPageToken")
  field(:wait_new_event, 5, type: :bool, json_name: "waitNewEvent")

  field(:history_event_filter_type, 6,
    type: Temporal.Protos.Temporal.Api.Enums.V1.HistoryEventFilterType,
    json_name: "historyEventFilterType",
    enum: true
  )

  field(:skip_archival, 7, type: :bool, json_name: "skipArchival")
end
