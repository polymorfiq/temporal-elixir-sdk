defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionUpdateCompletedEventAttributes do
  @moduledoc """
  Automatically generated module for WorkflowExecutionUpdateCompletedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`accepted_event_id`** | `int64` | The event ID indicating the acceptance of this update. |
  | 1 | **`meta`** | `Temporal.Protos.Temporal.Api.Update.V1.Meta` | The metadata about this update. |
  | 2 | **`outcome`** | `Temporal.Protos.Temporal.Api.Update.V1.Outcome` | The outcome of executing the workflow update function. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :meta, 1, type: Temporal.Protos.Temporal.Api.Update.V1.Meta
  field :accepted_event_id, 3, type: :int64, json_name: "acceptedEventId"
  field :outcome, 2, type: Temporal.Protos.Temporal.Api.Update.V1.Outcome
end
