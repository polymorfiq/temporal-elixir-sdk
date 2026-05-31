defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondActivityTaskFailedResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:failures, 1, repeated: true, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure)
end
