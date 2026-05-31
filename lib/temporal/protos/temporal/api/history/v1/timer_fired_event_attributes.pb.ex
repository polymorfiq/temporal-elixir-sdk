defmodule Temporal.Protos.Temporal.Api.History.V1.TimerFiredEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:timer_id, 1, type: :string, json_name: "timerId")
  field(:started_event_id, 2, type: :int64, json_name: "startedEventId")
end
