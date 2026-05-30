defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerConfigResponse do
  @moduledoc """
  Automatically generated module for UpdateWorkerConfigResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`worker_config`** | `Temporal.Protos.Temporal.Api.Sdk.V1.WorkerConfig` | The worker configuration. Will be returned if the command was sent to a single worker. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :response, 0

  field :worker_config, 1,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.WorkerConfig,
    json_name: "workerConfig",
    oneof: 0
end
