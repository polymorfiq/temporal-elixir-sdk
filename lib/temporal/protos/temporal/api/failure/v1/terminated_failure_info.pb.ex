defmodule Temporal.Protos.Temporal.Api.Failure.V1.TerminatedFailureInfo do
  @moduledoc """
  Automatically generated module for TerminatedFailureInfo

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`identity`** | `string` | The identity of the worker or client that requested the termination. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :identity, 1, type: :string
end
