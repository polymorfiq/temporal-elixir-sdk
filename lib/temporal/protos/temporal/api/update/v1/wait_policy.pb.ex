defmodule Temporal.Protos.Temporal.Api.Update.V1.WaitPolicy do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:lifecycle_stage, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.UpdateWorkflowExecutionLifecycleStage,
    json_name: "lifecycleStage",
    enum: true
  )
end
