defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkflowExecutionResponse do
  @moduledoc """
  Automatically generated module for UpdateWorkflowExecutionResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`link`** | `Temporal.Protos.Temporal.Api.Common.V1.Link` | Link to the update event. May be null if the update has not yet been accepted. |
  | 2 | **`outcome`** | `Temporal.Protos.Temporal.Api.Update.V1.Outcome` | The outcome of the Update if and only if the Workflow Update |
  | 3 | **`stage`** | `Temporal.Protos.Temporal.Api.Enums.V1.UpdateWorkflowExecutionLifecycleStage` | The most advanced lifecycle stage that the Update is known to have |
  | 1 | **`update_ref`** | `Temporal.Protos.Temporal.Api.Update.V1.UpdateRef` | Enough information for subsequent poll calls if needed. Never null. |

  ### Additional Notes

    * `outcome` (`Temporal.Protos.Temporal.Api.Update.V1.Outcome`): The outcome of the Update if and only if the Workflow Update
      has completed. If this response is being returned before the Update has
      completed then this field will not be set.
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

  field :update_ref, 1,
    type: Temporal.Protos.Temporal.Api.Update.V1.UpdateRef,
    json_name: "updateRef"

  field :outcome, 2, type: Temporal.Protos.Temporal.Api.Update.V1.Outcome

  field :stage, 3,
    type: Temporal.Protos.Temporal.Api.Enums.V1.UpdateWorkflowExecutionLifecycleStage,
    enum: true

  field :link, 4, type: Temporal.Protos.Temporal.Api.Common.V1.Link
end
