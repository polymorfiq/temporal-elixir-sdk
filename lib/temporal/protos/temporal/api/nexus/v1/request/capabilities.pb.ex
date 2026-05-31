defmodule Temporal.Protos.Temporal.Api.Nexus.V1.Request.Capabilities do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:temporal_failure_responses, 1, type: :bool, json_name: "temporalFailureResponses")
end
