defmodule Temporal.Protos.Temporal.Api.Sdk.V1.StackTrace do
  @moduledoc """
  Collection of FileLocation messages from a single stack.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`locations`** | `Temporal.Protos.Temporal.Api.Sdk.V1.StackTraceFileLocation` | Collection of `FileLocation`s, each for a stack frame that comprise a stack trace. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :locations, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.StackTraceFileLocation
end
