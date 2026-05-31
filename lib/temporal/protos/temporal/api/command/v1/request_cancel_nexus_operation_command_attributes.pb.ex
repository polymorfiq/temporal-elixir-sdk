defmodule Temporal.Protos.Temporal.Api.Command.V1.RequestCancelNexusOperationCommandAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId")
end
