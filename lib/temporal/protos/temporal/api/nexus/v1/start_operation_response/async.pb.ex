defmodule Temporal.Protos.Temporal.Api.Nexus.V1.StartOperationResponse.Async do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:operation_id, 1, type: :string, json_name: "operationId", deprecated: true)
  field(:links, 2, repeated: true, type: Temporal.Protos.Temporal.Api.Nexus.V1.Link)
  field(:operation_token, 3, type: :string, json_name: "operationToken")
end
