defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RecordWorkerHeartbeatRequest do
  @moduledoc """
  Automatically generated module for RecordWorkerHeartbeatRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`identity`** | `string` | The identity of the client who initiated this request. |
  | 1 | **`namespace`** | `string` | Namespace this worker belongs to. |
  | 4 | **`resource_id`** | `string` | Resource ID for routing. Contains the worker grouping key. |
  | 3 | **`worker_heartbeat`** | `Temporal.Protos.Temporal.Api.Worker.V1.WorkerHeartbeat` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :identity, 2, type: :string

  field :worker_heartbeat, 3,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Worker.V1.WorkerHeartbeat,
    json_name: "workerHeartbeat"

  field :resource_id, 4, type: :string, json_name: "resourceId"
end
