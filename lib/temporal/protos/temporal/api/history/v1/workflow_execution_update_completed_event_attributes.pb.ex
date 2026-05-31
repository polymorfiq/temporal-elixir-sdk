defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionUpdateCompletedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:meta, 1, type: Temporal.Protos.Temporal.Api.Update.V1.Meta)
  field(:accepted_event_id, 3, type: :int64, json_name: "acceptedEventId")
  field(:outcome, 2, type: Temporal.Protos.Temporal.Api.Update.V1.Outcome)
end
