defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PollWorkflowExecutionUpdateRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)

  field(:update_ref, 2,
    type: Temporal.Protos.Temporal.Api.Update.V1.UpdateRef,
    json_name: "updateRef"
  )

  field(:identity, 3, type: :string)

  field(:wait_policy, 4,
    type: Temporal.Protos.Temporal.Api.Update.V1.WaitPolicy,
    json_name: "waitPolicy"
  )
end
