defmodule Temporal.Protos.Temporal.Api.Sdk.V1.EnhancedStackTrace.SourcesEntry do
  @moduledoc false
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:key, 1, type: :string)
  field(:value, 2, type: Temporal.Protos.Temporal.Api.Sdk.V1.StackTraceFileSlice)
end
