defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListWorkersResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:workers_info, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Worker.V1.WorkerInfo,
    json_name: "workersInfo",
    deprecated: true
  )

  field(:workers, 3, repeated: true, type: Temporal.Protos.Temporal.Api.Worker.V1.WorkerListInfo)
  field(:next_page_token, 2, type: :bytes, json_name: "nextPageToken")
end
