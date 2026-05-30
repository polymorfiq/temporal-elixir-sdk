defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkerResponse do
  @moduledoc """
  Automatically generated module for DescribeWorkerResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`worker_info`** | `Temporal.Protos.Temporal.Api.Worker.V1.WorkerInfo` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :worker_info, 1,
    type: Temporal.Protos.Temporal.Api.Worker.V1.WorkerInfo,
    json_name: "workerInfo"
end
