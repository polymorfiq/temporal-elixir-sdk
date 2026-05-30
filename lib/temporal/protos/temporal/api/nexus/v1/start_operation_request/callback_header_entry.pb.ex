defmodule Temporal.Protos.Temporal.Api.Nexus.V1.StartOperationRequest.CallbackHeaderEntry do
  @moduledoc """
  A request to start an operation.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` | Name of service to start the operation in. |
  | 2 | **`value`** | `string` | Type of operation to start. |

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: :string
end
