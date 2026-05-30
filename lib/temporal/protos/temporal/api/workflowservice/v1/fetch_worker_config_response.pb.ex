defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.FetchWorkerConfigResponse do
  @moduledoc """
  Automatically generated module for FetchWorkerConfigResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`worker_config`** | `Temporal.Protos.Temporal.Api.Sdk.V1.WorkerConfig` | The worker configuration. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :worker_config, 1,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.WorkerConfig,
    json_name: "workerConfig"
end
