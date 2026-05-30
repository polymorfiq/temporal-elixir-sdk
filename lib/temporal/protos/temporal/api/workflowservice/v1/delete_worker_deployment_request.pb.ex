defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DeleteWorkerDeploymentRequest do
  @moduledoc """
  Deletes records of (an old) Deployment. A deployment can only be deleted if
  it has no Version in it.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`deployment_name`** | `string` |  |
  | 3 | **`identity`** | `string` | Optional. The identity of the client who initiated this request. |
  | 1 | **`namespace`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :deployment_name, 2, type: :string, json_name: "deploymentName"
  field :identity, 3, type: :string
end
