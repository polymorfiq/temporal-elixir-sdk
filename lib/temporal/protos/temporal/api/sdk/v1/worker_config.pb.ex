defmodule Temporal.Protos.Temporal.Api.Sdk.V1.WorkerConfig do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:poller_behavior, 0)

  field(:workflow_cache_size, 1, type: :int32, json_name: "workflowCacheSize")

  field(:simple_poller_behavior, 2,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.WorkerConfig.SimplePollerBehavior,
    json_name: "simplePollerBehavior",
    oneof: 0
  )

  field(:autoscaling_poller_behavior, 3,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.WorkerConfig.AutoscalingPollerBehavior,
    json_name: "autoscalingPollerBehavior",
    oneof: 0
  )
end
