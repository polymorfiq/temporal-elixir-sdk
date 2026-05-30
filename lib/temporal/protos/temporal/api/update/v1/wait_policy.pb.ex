defmodule Temporal.Protos.Temporal.Api.Update.V1.WaitPolicy do
  @moduledoc """
  Specifies client's intent to wait for Update results.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`lifecycle_stage`** | `Temporal.Protos.Temporal.Api.Enums.V1.UpdateWorkflowExecutionLifecycleStage` | Indicates the Update lifecycle stage that the Update must reach before |

  ### Additional Notes

    * `lifecycle_stage` (`Temporal.Protos.Temporal.Api.Enums.V1.UpdateWorkflowExecutionLifecycleStage`): Indicates the Update lifecycle stage that the Update must reach before
      API call is returned.
      NOTE: This field works together with API call timeout which is limited by
      server timeout (maximum wait time). If server timeout is expired before
      user specified timeout, API call returns even if specified stage is not reached.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :lifecycle_stage, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.UpdateWorkflowExecutionLifecycleStage,
    json_name: "lifecycleStage",
    enum: true
end
