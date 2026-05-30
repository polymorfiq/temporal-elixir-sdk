defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PollWorkflowExecutionUpdateRequest do
  @moduledoc """
  Automatically generated module for PollWorkflowExecutionUpdateRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`identity`** | `string` | The identity of the worker/client who is polling this Update outcome. |
  | 1 | **`namespace`** | `string` | The namespace of the Workflow Execution to which the Update was |
  | 2 | **`update_ref`** | `Temporal.Protos.Temporal.Api.Update.V1.UpdateRef` | The Update reference returned in the initial UpdateWorkflowExecutionResponse. |
  | 4 | **`wait_policy`** | `Temporal.Protos.Temporal.Api.Update.V1.WaitPolicy` | Specifies client's intent to wait for Update results. |

  ### Additional Notes

    * `namespace` (`string`): The namespace of the Workflow Execution to which the Update was
      originally issued.
    * `wait_policy` (`Temporal.Protos.Temporal.Api.Update.V1.WaitPolicy`): Specifies client's intent to wait for Update results.
      Omit to request a non-blocking poll.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string

  field :update_ref, 2,
    type: Temporal.Protos.Temporal.Api.Update.V1.UpdateRef,
    json_name: "updateRef"

  field :identity, 3, type: :string

  field :wait_policy, 4,
    type: Temporal.Protos.Temporal.Api.Update.V1.WaitPolicy,
    json_name: "waitPolicy"
end
