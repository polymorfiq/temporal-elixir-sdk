defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.FetchWorkerConfigResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:worker_config, 1,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.WorkerConfig,
    json_name: "workerConfig"
  )
end
