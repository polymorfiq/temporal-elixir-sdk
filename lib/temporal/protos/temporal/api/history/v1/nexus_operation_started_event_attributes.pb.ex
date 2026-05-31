defmodule Temporal.Protos.Temporal.Api.History.V1.NexusOperationStartedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId")
  field(:operation_id, 3, type: :string, json_name: "operationId", deprecated: true)
  field(:request_id, 4, type: :string, json_name: "requestId")
  field(:operation_token, 5, type: :string, json_name: "operationToken")
end
