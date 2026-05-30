defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListWorkerDeploymentsResponse do
  @moduledoc """
  Automatically generated module for ListWorkerDeploymentsResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`next_page_token`** | `bytes` |  |
  | 2 | **`worker_deployments`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.ListWorkerDeploymentsResponse.WorkerDeploymentSummary` | The list of worker deployments. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :next_page_token, 1, type: :bytes, json_name: "nextPageToken"

  field :worker_deployments, 2,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.ListWorkerDeploymentsResponse.WorkerDeploymentSummary,
    json_name: "workerDeployments"
end
