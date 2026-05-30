defmodule Temporal.Protos.Temporal.Api.Common.V1.Link.WorkflowEvent.RequestIdReference do
  @moduledoc """
  Link can be associated with history events. It might contain information about an external entity
  related to the history event. For example, workflow A makes a Nexus call that starts workflow B:
  in this case, a history event in workflow A could contain a Link to the workflow started event in
  workflow B, and vice-versa.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`event_type`** | `Temporal.Protos.Temporal.Api.Enums.V1.EventType` |  |
  | 1 | **`request_id`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :request_id, 1, type: :string, json_name: "requestId"

  field :event_type, 2,
    type: Temporal.Protos.Temporal.Api.Enums.V1.EventType,
    json_name: "eventType",
    enum: true
end
