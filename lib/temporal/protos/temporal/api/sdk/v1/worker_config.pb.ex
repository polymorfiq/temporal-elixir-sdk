defmodule Temporal.Protos.Temporal.Api.Sdk.V1.WorkerConfig do
  @moduledoc """
  Automatically generated module for WorkerConfig

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`autoscaling_poller_behavior`** | `Temporal.Protos.Temporal.Api.Sdk.V1.WorkerConfig.AutoscalingPollerBehavior` |  |
  | 2 | **`simple_poller_behavior`** | `Temporal.Protos.Temporal.Api.Sdk.V1.WorkerConfig.SimplePollerBehavior` |  |
  | 1 | **`workflow_cache_size`** | `int32` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :poller_behavior, 0

  field :workflow_cache_size, 1, type: :int32, json_name: "workflowCacheSize"

  field :simple_poller_behavior, 2,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.WorkerConfig.SimplePollerBehavior,
    json_name: "simplePollerBehavior",
    oneof: 0

  field :autoscaling_poller_behavior, 3,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.WorkerConfig.AutoscalingPollerBehavior,
    json_name: "autoscalingPollerBehavior",
    oneof: 0
end
