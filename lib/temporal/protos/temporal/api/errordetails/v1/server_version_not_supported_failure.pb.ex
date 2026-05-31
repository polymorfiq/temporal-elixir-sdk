defmodule Temporal.Protos.Temporal.Api.Errordetails.V1.ServerVersionNotSupportedFailure do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:server_version, 1, type: :string, json_name: "serverVersion")

  field(:client_supported_server_versions, 2,
    type: :string,
    json_name: "clientSupportedServerVersions"
  )
end
