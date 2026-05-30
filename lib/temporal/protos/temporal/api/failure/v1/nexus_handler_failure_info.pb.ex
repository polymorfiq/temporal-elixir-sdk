defmodule Temporal.Protos.Temporal.Api.Failure.V1.NexusHandlerFailureInfo do
  @moduledoc """
  Automatically generated module for NexusHandlerFailureInfo

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`retry_behavior`** | `Temporal.Protos.Temporal.Api.Enums.V1.NexusHandlerErrorRetryBehavior` | Retry behavior, defaults to the retry behavior of the error type as defined in the spec. |
  | 1 | **`type`** | `string` | The Nexus error type as defined in the spec: |

  ### Additional Notes

    * `type` (`string`): The Nexus error type as defined in the spec:
      https://github.com/nexus-rpc/api/blob/main/SPEC.md#predefined-handler-errors.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :type, 1, type: :string

  field :retry_behavior, 2,
    type: Temporal.Protos.Temporal.Api.Enums.V1.NexusHandlerErrorRetryBehavior,
    json_name: "retryBehavior",
    enum: true
end
