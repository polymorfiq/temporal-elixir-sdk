defmodule Temporal.Protos.Temporal.Api.Errordetails.V1.ClientVersionNotSupportedFailure do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:client_version, 1, type: :string, json_name: "clientVersion")
  field(:client_name, 2, type: :string, json_name: "clientName")
  field(:supported_versions, 3, type: :string, json_name: "supportedVersions")
end
