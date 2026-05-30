defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.GetWorkflowExecutionHistoryResponse do
  @moduledoc """
  Automatically generated module for GetWorkflowExecutionHistoryResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`archived`** | `bool` |  |
  | 1 | **`history`** | `Temporal.Protos.Temporal.Api.History.V1.History` |  |
  | 3 | **`next_page_token`** | `bytes` | Will be set if there are more history events than were included in this response |
  | 2 | **`raw_history`** | `Temporal.Protos.Temporal.Api.Common.V1.DataBlob` | Raw history is an alternate representation of history that may be returned if configured on |

  ### Additional Notes

    * `raw_history` (`Temporal.Protos.Temporal.Api.Common.V1.DataBlob`): Raw history is an alternate representation of history that may be returned if configured on
      the frontend. This is not supported by all SDKs. Either this or `history` will be set.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :history, 1, type: Temporal.Protos.Temporal.Api.History.V1.History

  field :raw_history, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.DataBlob,
    json_name: "rawHistory"

  field :next_page_token, 3, type: :bytes, json_name: "nextPageToken"
  field :archived, 4, type: :bool
end
