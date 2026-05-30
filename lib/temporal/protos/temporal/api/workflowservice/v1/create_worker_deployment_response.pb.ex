defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.CreateWorkerDeploymentResponse do
  @moduledoc """
  Automatically generated module for CreateWorkerDeploymentResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`conflict_token`** | `bytes` | This value is returned so that it can be optionally passed to APIs that |

  ### Additional Notes

    * `conflict_token` (`bytes`): This value is returned so that it can be optionally passed to APIs that
      write to the WorkerDeployment state to ensure that the state did not
      change between this API call and a future write.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :conflict_token, 1, type: :bytes, json_name: "conflictToken"
end
