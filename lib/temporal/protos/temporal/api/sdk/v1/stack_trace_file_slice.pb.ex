defmodule Temporal.Protos.Temporal.Api.Sdk.V1.StackTraceFileSlice do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:line_offset, 1, type: :uint32, json_name: "lineOffset")
  field(:content, 2, type: :string)
end
