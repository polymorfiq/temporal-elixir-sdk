defmodule Temporal.Protos.Temporal.Api.Sdk.V1.EnhancedStackTrace do
  @moduledoc """
  Internal structure used to create worker stack traces with references to code.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`sdk`** | `Temporal.Protos.Temporal.Api.Sdk.V1.StackTraceSDKInfo` | Information pertaining to the SDK that the trace has been captured from. |
  | 2 | **`sources`** | `Temporal.Protos.Temporal.Api.Sdk.V1.EnhancedStackTrace.SourcesEntry` | Mapping of file path to file contents. |
  | 3 | **`stacks`** | `Temporal.Protos.Temporal.Api.Sdk.V1.StackTrace` | Collection of stacks captured. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :sdk, 1, type: Temporal.Protos.Temporal.Api.Sdk.V1.StackTraceSDKInfo

  field :sources, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.EnhancedStackTrace.SourcesEntry,
    map: true

  field :stacks, 3, repeated: true, type: Temporal.Protos.Temporal.Api.Sdk.V1.StackTrace
end
