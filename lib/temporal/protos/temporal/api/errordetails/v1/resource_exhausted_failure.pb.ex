defmodule Temporal.Protos.Temporal.Api.Errordetails.V1.ResourceExhaustedFailure do
  @moduledoc """
  Automatically generated module for ResourceExhaustedFailure

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`cause`** | `Temporal.Protos.Temporal.Api.Enums.V1.ResourceExhaustedCause` |  |
  | 2 | **`scope`** | `Temporal.Protos.Temporal.Api.Enums.V1.ResourceExhaustedScope` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :cause, 1, type: Temporal.Protos.Temporal.Api.Enums.V1.ResourceExhaustedCause, enum: true
  field :scope, 2, type: Temporal.Protos.Temporal.Api.Enums.V1.ResourceExhaustedScope, enum: true
end
