defmodule Temporal.Protos.Temporal.Api.Nexus.V1.StartOperationResponse do
  @moduledoc """
  Response variant for StartOperationRequest.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`async_success`** | `Temporal.Protos.Temporal.Api.Nexus.V1.StartOperationResponse.Async` |  |
  | 4 | **`failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | The operation completed unsuccessfully (failed or canceled). |
  | 3 | **`operation_error`** | `Temporal.Protos.Temporal.Api.Nexus.V1.UnsuccessfulOperationError` | The operation completed unsuccessfully (failed or canceled). |
  | 1 | **`sync_success`** | `Temporal.Protos.Temporal.Api.Nexus.V1.StartOperationResponse.Sync` |  |

  ### Additional Notes

    * `failure` (`Temporal.Protos.Temporal.Api.Failure.V1.Failure`): The operation completed unsuccessfully (failed or canceled).
      Failure object must contain an ApplicationFailureInfo or CanceledFailureInfo object.
    * `operation_error` (`Temporal.Protos.Temporal.Api.Nexus.V1.UnsuccessfulOperationError`): The operation completed unsuccessfully (failed or canceled).
      Deprecated. Use the failure variant instead.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :variant, 0

  field :sync_success, 1,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.StartOperationResponse.Sync,
    json_name: "syncSuccess",
    oneof: 0

  field :async_success, 2,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.StartOperationResponse.Async,
    json_name: "asyncSuccess",
    oneof: 0

  field :operation_error, 3,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.UnsuccessfulOperationError,
    json_name: "operationError",
    oneof: 0,
    deprecated: true

  field :failure, 4, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure, oneof: 0
end
