defmodule Temporal.Protos.Temporal.Api.Nexus.V1.Endpoint do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:version, 1, type: :int64)
  field(:id, 2, type: :string)
  field(:spec, 3, type: Temporal.Protos.Temporal.Api.Nexus.V1.EndpointSpec)
  field(:created_time, 4, type: Google.Protobuf.Timestamp, json_name: "createdTime")
  field(:last_modified_time, 5, type: Google.Protobuf.Timestamp, json_name: "lastModifiedTime")
  field(:url_prefix, 6, type: :string, json_name: "urlPrefix")
end
