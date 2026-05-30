defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.GetWorkflowExecutionHistoryRequest do
  @moduledoc """
  Automatically generated module for GetWorkflowExecutionHistoryRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` |  |
  | 6 | **`history_event_filter_type`** | `Temporal.Protos.Temporal.Api.Enums.V1.HistoryEventFilterType` | Filter returned events such that they match the specified filter type. |
  | 3 | **`maximum_page_size`** | `int32` |  |
  | 1 | **`namespace`** | `string` |  |
  | 4 | **`next_page_token`** | `bytes` | If a `GetWorkflowExecutionHistoryResponse` or a `PollWorkflowTaskQueueResponse` had one of |
  | 7 | **`skip_archival`** | `bool` |  |
  | 5 | **`wait_new_event`** | `bool` | If set to true, the RPC call will not resolve until there is a new event which matches |

  ### Additional Notes

    * `history_event_filter_type` (`Temporal.Protos.Temporal.Api.Enums.V1.HistoryEventFilterType`): Filter returned events such that they match the specified filter type.
      Default: HISTORY_EVENT_FILTER_TYPE_ALL_EVENT.
    * `next_page_token` (`bytes`): If a `GetWorkflowExecutionHistoryResponse` or a `PollWorkflowTaskQueueResponse` had one of
      these, it should be passed here to fetch the next page.
    * `wait_new_event` (`bool`): If set to true, the RPC call will not resolve until there is a new event which matches
      the `history_event_filter_type`, or a timeout is hit.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :execution, 2, type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution
  field :maximum_page_size, 3, type: :int32, json_name: "maximumPageSize"
  field :next_page_token, 4, type: :bytes, json_name: "nextPageToken"
  field :wait_new_event, 5, type: :bool, json_name: "waitNewEvent"

  field :history_event_filter_type, 6,
    type: Temporal.Protos.Temporal.Api.Enums.V1.HistoryEventFilterType,
    json_name: "historyEventFilterType",
    enum: true

  field :skip_archival, 7, type: :bool, json_name: "skipArchival"
end
