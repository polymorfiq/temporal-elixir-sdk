defmodule Temporal.Protos.Temporal.Api.Nexusservices.Workerservice.V1.ExecuteCommandsResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:results, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Worker.V1.WorkerCommandResult
  )
end
