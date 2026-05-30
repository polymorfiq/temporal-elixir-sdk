defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.CreateWorkerDeploymentRequest do
  @moduledoc """
  Creates a new WorkerDeployment.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`deployment_name`** | `string` | The name of the Worker Deployment to create. If a Worker Deployment with |
  | 4 | **`identity`** | `string` | Optional. The identity of the client who initiated this request. |
  | 1 | **`namespace`** | `string` |  |
  | 5 | **`request_id`** | `string` | A unique identifier for this create request for idempotence. Typically UUIDv4. |

  ### Additional Notes

    * `deployment_name` (`string`): The name of the Worker Deployment to create. If a Worker Deployment with
      this name already exists, an error will be returned.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :deployment_name, 2, type: :string, json_name: "deploymentName"
  field :identity, 4, type: :string
  field :request_id, 5, type: :string, json_name: "requestId"
end
