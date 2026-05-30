defmodule Temporal.Protos.Temporal.Api.Failure.V1.CanceledFailureInfo do
  @moduledoc """
  Automatically generated module for CanceledFailureInfo

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`details`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` |  |
  | 2 | **`identity`** | `string` | The identity of the worker or client that requested the cancellation. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :details, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
  field :identity, 2, type: :string
end
