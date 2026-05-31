defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkflowExecutionResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:update_ref, 1,
    type: Temporal.Protos.Temporal.Api.Update.V1.UpdateRef,
    json_name: "updateRef"
  )

  field(:outcome, 2, type: Temporal.Protos.Temporal.Api.Update.V1.Outcome)

  field(:stage, 3,
    type: Temporal.Protos.Temporal.Api.Enums.V1.UpdateWorkflowExecutionLifecycleStage,
    enum: true
  )

  field(:link, 4, type: Temporal.Protos.Temporal.Api.Common.V1.Link)
end
