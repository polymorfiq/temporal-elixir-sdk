defmodule Temporal.Protos.Temporal.Api.Nexus.V1.HandlerError do
  @moduledoc """
  Automatically generated module for HandlerError

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`error_type`** | `string` | See https://github.com/nexus-rpc/api/blob/main/SPEC.md#predefined-handler-errors. |
  | 2 | **`failure`** | `Temporal.Protos.Temporal.Api.Nexus.V1.Failure` |  |
  | 3 | **`retry_behavior`** | `Temporal.Protos.Temporal.Api.Enums.V1.NexusHandlerErrorRetryBehavior` | Retry behavior, defaults to the retry behavior of the error type as defined in the spec. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :error_type, 1, type: :string, json_name: "errorType"
  field :failure, 2, type: Temporal.Protos.Temporal.Api.Nexus.V1.Failure

  field :retry_behavior, 3,
    type: Temporal.Protos.Temporal.Api.Enums.V1.NexusHandlerErrorRetryBehavior,
    json_name: "retryBehavior",
    enum: true
end
