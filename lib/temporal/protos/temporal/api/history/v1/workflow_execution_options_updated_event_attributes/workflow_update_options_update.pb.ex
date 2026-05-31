defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionOptionsUpdatedEventAttributes.WorkflowUpdateOptionsUpdate do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:update_id, 1, type: :string, json_name: "updateId")
  field(:attached_request_id, 2, type: :string, json_name: "attachedRequestId")

  field(:attached_completion_callbacks, 3,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.Callback,
    json_name: "attachedCompletionCallbacks"
  )
end
