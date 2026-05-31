defmodule Temporal.Protos.Temporal.Api.History.V1.NexusOperationCanceledEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId")
  field(:failure, 2, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure)
  field(:request_id, 3, type: :string, json_name: "requestId")
end
