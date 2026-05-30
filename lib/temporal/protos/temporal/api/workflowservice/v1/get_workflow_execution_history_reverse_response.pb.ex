defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.GetWorkflowExecutionHistoryReverseResponse do
  @moduledoc """
  Automatically generated module for GetWorkflowExecutionHistoryReverseResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`history`** | `Temporal.Protos.Temporal.Api.History.V1.History` |  |
  | 3 | **`next_page_token`** | `bytes` | Will be set if there are more history events than were included in this response |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :history, 1, type: Temporal.Protos.Temporal.Api.History.V1.History
  field :next_page_token, 3, type: :bytes, json_name: "nextPageToken"
end
