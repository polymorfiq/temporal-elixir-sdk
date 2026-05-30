defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeNexusOperationExecutionResponse do
  @moduledoc """
  Automatically generated module for DescribeNexusOperationExecutionResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | The failure if the operation completed unsuccessfully. |
  | 2 | **`info`** | `Temporal.Protos.Temporal.Api.Nexus.V1.NexusOperationExecutionInfo` | Information about the operation. |
  | 3 | **`input`** | `Temporal.Protos.Temporal.Api.Common.V1.Payload` | Serialized operation input, passed as the request payload. |
  | 6 | **`long_poll_token`** | `bytes` | Token for follow-on long-poll requests. Absent only if the operation is complete. |
  | 4 | **`result`** | `Temporal.Protos.Temporal.Api.Common.V1.Payload` | The result if the operation completed successfully. |
  | 1 | **`run_id`** | `string` | The run ID of the operation, useful when run_id was not specified in the request. |

  ### Additional Notes

    * `input` (`Temporal.Protos.Temporal.Api.Common.V1.Payload`): Serialized operation input, passed as the request payload.
      Only set if include_input was true in the request.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :outcome, 0

  field :run_id, 1, type: :string, json_name: "runId"
  field :info, 2, type: Temporal.Protos.Temporal.Api.Nexus.V1.NexusOperationExecutionInfo
  field :input, 3, type: Temporal.Protos.Temporal.Api.Common.V1.Payload
  field :result, 4, type: Temporal.Protos.Temporal.Api.Common.V1.Payload, oneof: 0
  field :failure, 5, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure, oneof: 0
  field :long_poll_token, 6, type: :bytes, json_name: "longPollToken"
end
