defmodule Temporal.Protos.Temporal.Api.Common.V1.Link.WorkflowEvent do
  @moduledoc """
  Link can be associated with history events. It might contain information about an external entity
  related to the history event. For example, workflow A makes a Nexus call that starts workflow B:
  in this case, a history event in workflow A could contain a Link to the workflow started event in
  workflow B, and vice-versa.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 100 | **`event_ref`** | `Temporal.Protos.Temporal.Api.Common.V1.Link.WorkflowEvent.EventReference` |  |
  | 1 | **`namespace`** | `string` |  |
  | 101 | **`request_id_ref`** | `Temporal.Protos.Temporal.Api.Common.V1.Link.WorkflowEvent.RequestIdReference` |  |
  | 3 | **`run_id`** | `string` |  |
  | 2 | **`workflow_id`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :reference, 0

  field :namespace, 1, type: :string
  field :workflow_id, 2, type: :string, json_name: "workflowId"
  field :run_id, 3, type: :string, json_name: "runId"

  field :event_ref, 100,
    type: Temporal.Protos.Temporal.Api.Common.V1.Link.WorkflowEvent.EventReference,
    json_name: "eventRef",
    oneof: 0

  field :request_id_ref, 101,
    type: Temporal.Protos.Temporal.Api.Common.V1.Link.WorkflowEvent.RequestIdReference,
    json_name: "requestIdRef",
    oneof: 0
end
