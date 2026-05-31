defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.GetSystemInfoResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:server_version, 1, type: :string, json_name: "serverVersion")

  field(:capabilities, 2,
    type: Temporal.Protos.Temporal.Api.Workflowservice.V1.GetSystemInfoResponse.Capabilities
  )
end
