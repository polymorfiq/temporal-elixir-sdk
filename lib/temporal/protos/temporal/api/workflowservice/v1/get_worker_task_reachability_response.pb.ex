defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.GetWorkerTaskReachabilityResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:build_id_reachability, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.BuildIdReachability,
    json_name: "buildIdReachability"
  )
end
