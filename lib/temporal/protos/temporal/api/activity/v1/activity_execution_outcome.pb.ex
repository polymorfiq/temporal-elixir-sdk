defmodule Temporal.Protos.Temporal.Api.Activity.V1.ActivityExecutionOutcome do
  @moduledoc """
  The outcome of a completed activity execution: either a successful result or a failure.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | The failure if the activity completed unsuccessfully. |
  | 1 | **`result`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | The result if the activity completed successfully. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :value, 0

  field :result, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads, oneof: 0
  field :failure, 2, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure, oneof: 0
end
