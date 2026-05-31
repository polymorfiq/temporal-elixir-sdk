defmodule Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleState do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:notes, 1, type: :string)
  field(:paused, 2, type: :bool)
  field(:limited_actions, 3, type: :bool, json_name: "limitedActions")
  field(:remaining_actions, 4, type: :int64, json_name: "remainingActions")
end
