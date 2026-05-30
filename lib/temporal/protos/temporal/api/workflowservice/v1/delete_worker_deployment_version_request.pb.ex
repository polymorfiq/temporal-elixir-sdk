defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DeleteWorkerDeploymentVersionRequest do
  @moduledoc """
  Used for manual deletion of Versions. User can delete a Version only when all the
  following conditions are met:
   - It is not the Current or Ramping Version of its Deployment.
   - It has no active pollers (none of the task queues in the Version have pollers)
   - It is not draining (see WorkerDeploymentVersionInfo.drainage_info). This condition
     can be skipped by passing `skip-drainage=true`.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`deployment_version`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion` | Required. |
  | 4 | **`identity`** | `string` | Optional. The identity of the client who initiated this request. |
  | 1 | **`namespace`** | `string` |  |
  | 3 | **`skip_drainage`** | `bool` | Pass to force deletion even if the Version is draining. In this case the open pinned |
  | 2 | **`version`** | `string` | Deprecated. Use `deployment_version`. |

  ### Additional Notes

    * `skip_drainage` (`bool`): Pass to force deletion even if the Version is draining. In this case the open pinned
      workflows will be stuck until manually moved to another version by UpdateWorkflowExecutionOptions.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :version, 2, type: :string, deprecated: true

  field :deployment_version, 5,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "deploymentVersion"

  field :skip_drainage, 3, type: :bool, json_name: "skipDrainage"
  field :identity, 4, type: :string
end
