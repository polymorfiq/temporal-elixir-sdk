defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeNexusOperationExecutionRequest do
  @moduledoc """
  Automatically generated module for DescribeNexusOperationExecutionRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`include_input`** | `bool` | Include the input field in the response. |
  | 5 | **`include_outcome`** | `bool` | Include the outcome (result/failure) in the response if the operation has completed. |
  | 6 | **`long_poll_token`** | `bytes` | Token from a previous DescribeNexusOperationExecutionResponse. If present, this RPC will long-poll until operation |
  | 1 | **`namespace`** | `string` |  |
  | 2 | **`operation_id`** | `string` |  |
  | 3 | **`run_id`** | `string` | Operation run ID. If empty the request targets the latest run. |

  ### Additional Notes

    * `long_poll_token` (`bytes`): Token from a previous DescribeNexusOperationExecutionResponse. If present, this RPC will long-poll until operation
      state changes from the state encoded in this token. If absent, return current state immediately.
      If present, run_id must also be present.
      Note that operation state may change multiple times between requests, therefore it is not
      guaranteed that a client making a sequence of long-poll requests will see a complete
      sequence of state changes.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :operation_id, 2, type: :string, json_name: "operationId"
  field :run_id, 3, type: :string, json_name: "runId"
  field :include_input, 4, type: :bool, json_name: "includeInput"
  field :include_outcome, 5, type: :bool, json_name: "includeOutcome"
  field :long_poll_token, 6, type: :bytes, json_name: "longPollToken"
end
