defmodule Temporal.Protos.Temporal.Api.Update.V1.Outcome do
  @moduledoc """
  The outcome of a Workflow Update: success or failure.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` |  |
  | 1 | **`success`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :value, 0

  field :success, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads, oneof: 0
  field :failure, 2, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure, oneof: 0
end
