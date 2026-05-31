defmodule Temporal.Protos.Temporal.Api.Schedule.V1.SchedulePatch do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:trigger_immediately, 1,
    type: Temporal.Protos.Temporal.Api.Schedule.V1.TriggerImmediatelyRequest,
    json_name: "triggerImmediately"
  )

  field(:backfill_request, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Schedule.V1.BackfillRequest,
    json_name: "backfillRequest"
  )

  field(:pause, 3, type: :string)
  field(:unpause, 4, type: :string)
end
