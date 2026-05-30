defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListNexusOperationExecutionsRequest do
  @moduledoc """
  Automatically generated module for ListNexusOperationExecutionsRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`namespace`** | `string` |  |
  | 3 | **`next_page_token`** | `bytes` | Token returned in ListNexusOperationExecutionsResponse. |
  | 2 | **`page_size`** | `int32` | Max number of operations to return per page. |
  | 4 | **`query`** | `string` | Visibility query, see https://docs.temporal.io/list-filter for the syntax. |

  ### Additional Notes

    * `query` (`string`): Visibility query, see https://docs.temporal.io/list-filter for the syntax.
      Search attributes that are avaialble for Nexus operations include:
      - OperationId
      - RunId
      - Endpoint
      - Service
      - Operation
      - RequestId
      - StartTime
      - ExecutionTime
      - CloseTime
      - ExecutionStatus
      - ExecutionDuration
      - StateTransitionCount

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :page_size, 2, type: :int32, json_name: "pageSize"
  field :next_page_token, 3, type: :bytes, json_name: "nextPageToken"
  field :query, 4, type: :string
end
