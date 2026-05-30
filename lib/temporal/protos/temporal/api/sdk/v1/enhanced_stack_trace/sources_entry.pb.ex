defmodule Temporal.Protos.Temporal.Api.Sdk.V1.EnhancedStackTrace.SourcesEntry do
  @moduledoc """
  Internal structure used to create worker stack traces with references to code.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` | Information pertaining to the SDK that the trace has been captured from. |
  | 2 | **`value`** | `Temporal.Protos.Temporal.Api.Sdk.V1.StackTraceFileSlice` | Mapping of file path to file contents. |

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: Temporal.Protos.Temporal.Api.Sdk.V1.StackTraceFileSlice
end
