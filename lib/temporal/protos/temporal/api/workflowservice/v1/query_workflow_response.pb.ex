defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.QueryWorkflowResponse do
  @moduledoc """
  Automatically generated module for QueryWorkflowResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`query_rejected`** | `Temporal.Protos.Temporal.Api.Query.V1.QueryRejected` |  |
  | 1 | **`query_result`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :query_result, 1,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payloads,
    json_name: "queryResult"

  field :query_rejected, 2,
    type: Temporal.Protos.Temporal.Api.Query.V1.QueryRejected,
    json_name: "queryRejected"
end
