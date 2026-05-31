defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.BuildIdAssignmentRule do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:ramp, 0)

  field(:target_build_id, 1, type: :string, json_name: "targetBuildId")

  field(:percentage_ramp, 3,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.RampByPercentage,
    json_name: "percentageRamp",
    oneof: 0
  )
end
