defmodule Temporal.Protos.Temporal.Api.Common.V1.Link.WorkflowEvent do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:reference, 0)

  field(:namespace, 1, type: :string)
  field(:workflow_id, 2, type: :string, json_name: "workflowId")
  field(:run_id, 3, type: :string, json_name: "runId")

  field(:event_ref, 100,
    type: Temporal.Protos.Temporal.Api.Common.V1.Link.WorkflowEvent.EventReference,
    json_name: "eventRef",
    oneof: 0
  )

  field(:request_id_ref, 101,
    type: Temporal.Protos.Temporal.Api.Common.V1.Link.WorkflowEvent.RequestIdReference,
    json_name: "requestIdRef",
    oneof: 0
  )
end
