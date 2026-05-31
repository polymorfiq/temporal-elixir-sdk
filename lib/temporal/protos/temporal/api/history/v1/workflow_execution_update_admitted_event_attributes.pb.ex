defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionUpdateAdmittedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:request, 1, type: Temporal.Protos.Temporal.Api.Update.V1.Request)

  field(:origin, 2,
    type: Temporal.Protos.Temporal.Api.Enums.V1.UpdateAdmittedEventOrigin,
    enum: true
  )
end
