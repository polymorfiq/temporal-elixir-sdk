defmodule Temporal.Protos.Temporal.Api.Sdk.V1.EnhancedStackTrace do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:sdk, 1, type: Temporal.Protos.Temporal.Api.Sdk.V1.StackTraceSDKInfo)

  field(:sources, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.EnhancedStackTrace.SourcesEntry,
    map: true
  )

  field(:stacks, 3, repeated: true, type: Temporal.Protos.Temporal.Api.Sdk.V1.StackTrace)
end
