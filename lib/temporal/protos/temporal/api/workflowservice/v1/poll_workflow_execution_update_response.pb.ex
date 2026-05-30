defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PollWorkflowExecutionUpdateResponse do
  @moduledoc """
  Automatically generated module for PollWorkflowExecutionUpdateResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`outcome`** | `Temporal.Protos.Temporal.Api.Update.V1.Outcome` | The outcome of the update if and only if the update has completed. If |
  | 2 | **`stage`** | `Temporal.Protos.Temporal.Api.Enums.V1.UpdateWorkflowExecutionLifecycleStage` | The most advanced lifecycle stage that the Update is known to have |
  | 3 | **`update_ref`** | `Temporal.Protos.Temporal.Api.Update.V1.UpdateRef` | Sufficient information to address this Update. |

  ### Additional Notes

    * `outcome` (`Temporal.Protos.Temporal.Api.Update.V1.Outcome`): The outcome of the update if and only if the update has completed. If
      this response is being returned before the update has completed (e.g. due
      to the specification of a wait policy that only waits on
      UPDATE_WORKFLOW_EXECUTION_LIFECYCLE_STAGE_ACCEPTED) then this field will
      not be set.
    * `stage` (`Temporal.Protos.Temporal.Api.Enums.V1.UpdateWorkflowExecutionLifecycleStage`): The most advanced lifecycle stage that the Update is known to have
      reached, where lifecycle stages are ordered
      UPDATE_WORKFLOW_EXECUTION_LIFECYCLE_STAGE_UNSPECIFIED <
      UPDATE_WORKFLOW_EXECUTION_LIFECYCLE_STAGE_ADMITTED <
      UPDATE_WORKFLOW_EXECUTION_LIFECYCLE_STAGE_ACCEPTED <
      UPDATE_WORKFLOW_EXECUTION_LIFECYCLE_STAGE_COMPLETED.
      UNSPECIFIED will be returned if and only if the server's maximum wait
      time was reached before the Update reached the stage specified in the
      request WaitPolicy, and before the context deadline expired; clients may
      may then retry the call as needed.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :outcome, 1, type: Temporal.Protos.Temporal.Api.Update.V1.Outcome

  field :stage, 2,
    type: Temporal.Protos.Temporal.Api.Enums.V1.UpdateWorkflowExecutionLifecycleStage,
    enum: true

  field :update_ref, 3,
    type: Temporal.Protos.Temporal.Api.Update.V1.UpdateRef,
    json_name: "updateRef"
end
