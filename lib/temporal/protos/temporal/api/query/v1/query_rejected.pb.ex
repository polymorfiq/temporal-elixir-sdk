defmodule Temporal.Protos.Temporal.Api.Query.V1.QueryRejected do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:status, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkflowExecutionStatus,
    enum: true
  )
end
