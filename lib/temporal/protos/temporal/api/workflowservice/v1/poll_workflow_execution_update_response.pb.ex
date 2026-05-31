defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PollWorkflowExecutionUpdateResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:outcome, 1, type: Temporal.Protos.Temporal.Api.Update.V1.Outcome)

  field(:stage, 2,
    type: Temporal.Protos.Temporal.Api.Enums.V1.UpdateWorkflowExecutionLifecycleStage,
    enum: true
  )

  field(:update_ref, 3,
    type: Temporal.Protos.Temporal.Api.Update.V1.UpdateRef,
    json_name: "updateRef"
  )
end
