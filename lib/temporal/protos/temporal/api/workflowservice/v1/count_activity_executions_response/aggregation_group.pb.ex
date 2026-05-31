defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.CountActivityExecutionsResponse.AggregationGroup do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:group_values, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payload,
    json_name: "groupValues"
  )

  field(:count, 2, type: :int64)
end
