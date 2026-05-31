defmodule Temporal.Protos.Temporal.Api.Workflow.V1.PostResetOperation.SignalWorkflow do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:signal_name, 1, type: :string, json_name: "signalName")
  field(:input, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)
  field(:header, 3, type: Temporal.Protos.Temporal.Api.Common.V1.Header)
  field(:links, 4, repeated: true, type: Temporal.Protos.Temporal.Api.Common.V1.Link)
end
