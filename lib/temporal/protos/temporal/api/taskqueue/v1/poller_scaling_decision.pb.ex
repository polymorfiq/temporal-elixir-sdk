defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerScalingDecision do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:poll_request_delta_suggestion, 1, type: :int32, json_name: "pollRequestDeltaSuggestion")
end
