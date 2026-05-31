defmodule Temporal.Protos.Temporal.Api.Common.V1.MeteringMetadata do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:nonfirst_local_activity_execution_attempts, 13,
    type: :uint32,
    json_name: "nonfirstLocalActivityExecutionAttempts"
  )
end
