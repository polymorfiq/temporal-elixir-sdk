defmodule Temporal.Protos.Temporal.Api.Nexus.V1.UnsuccessfulOperationError do
  @moduledoc """
  Automatically generated module for UnsuccessfulOperationError

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`failure`** | `Temporal.Protos.Temporal.Api.Nexus.V1.Failure` |  |
  | 1 | **`operation_state`** | `string` | See https://github.com/nexus-rpc/api/blob/main/SPEC.md#operationinfo. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :operation_state, 1, type: :string, json_name: "operationState"
  field :failure, 2, type: Temporal.Protos.Temporal.Api.Nexus.V1.Failure
end
