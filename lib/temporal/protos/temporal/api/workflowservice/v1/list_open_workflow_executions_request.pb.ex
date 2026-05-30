defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListOpenWorkflowExecutionsRequest do
  @moduledoc """
  Automatically generated module for ListOpenWorkflowExecutionsRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`execution_filter`** | `Temporal.Protos.Temporal.Api.Filter.V1.WorkflowExecutionFilter` |  |
  | 2 | **`maximum_page_size`** | `int32` |  |
  | 1 | **`namespace`** | `string` |  |
  | 3 | **`next_page_token`** | `bytes` |  |
  | 4 | **`start_time_filter`** | `Temporal.Protos.Temporal.Api.Filter.V1.StartTimeFilter` |  |
  | 6 | **`type_filter`** | `Temporal.Protos.Temporal.Api.Filter.V1.WorkflowTypeFilter` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :filters, 0

  field :namespace, 1, type: :string
  field :maximum_page_size, 2, type: :int32, json_name: "maximumPageSize"
  field :next_page_token, 3, type: :bytes, json_name: "nextPageToken"

  field :start_time_filter, 4,
    type: Temporal.Protos.Temporal.Api.Filter.V1.StartTimeFilter,
    json_name: "startTimeFilter"

  field :execution_filter, 5,
    type: Temporal.Protos.Temporal.Api.Filter.V1.WorkflowExecutionFilter,
    json_name: "executionFilter",
    oneof: 0

  field :type_filter, 6,
    type: Temporal.Protos.Temporal.Api.Filter.V1.WorkflowTypeFilter,
    json_name: "typeFilter",
    oneof: 0
end
