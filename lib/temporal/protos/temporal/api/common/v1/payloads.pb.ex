defmodule Temporal.Protos.Temporal.Api.Common.V1.Payloads do
  @moduledoc """
  See `Payload`

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`payloads`** | `Temporal.Protos.Temporal.Api.Common.V1.Payload` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :payloads, 1, repeated: true, type: Temporal.Protos.Temporal.Api.Common.V1.Payload
end
