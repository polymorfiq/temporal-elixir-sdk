defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:last_access_time, 1, type: Google.Protobuf.Timestamp, json_name: "lastAccessTime")
  field(:identity, 2, type: :string)
  field(:rate_per_second, 3, type: :double, json_name: "ratePerSecond")

  field(:worker_version_capabilities, 4,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionCapabilities,
    json_name: "workerVersionCapabilities",
    deprecated: true
  )

  field(:deployment_options, 5,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentOptions,
    json_name: "deploymentOptions"
  )
end
