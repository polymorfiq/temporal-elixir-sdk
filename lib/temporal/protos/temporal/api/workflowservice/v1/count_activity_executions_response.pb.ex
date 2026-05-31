defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.CountActivityExecutionsResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:count, 1, type: :int64)

  field(:groups, 2,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.CountActivityExecutionsResponse.AggregationGroup
  )
end
