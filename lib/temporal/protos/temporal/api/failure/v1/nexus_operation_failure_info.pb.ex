defmodule Temporal.Protos.Temporal.Api.Failure.V1.NexusOperationFailureInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId")
  field(:endpoint, 2, type: :string)
  field(:service, 3, type: :string)
  field(:operation, 4, type: :string)
  field(:operation_id, 5, type: :string, json_name: "operationId", deprecated: true)
  field(:operation_token, 6, type: :string, json_name: "operationToken")
end
