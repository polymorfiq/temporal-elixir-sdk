defmodule Temporal.Protos.Temporal.Api.Query.V1.WorkflowQuery do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:query_type, 1, type: :string, json_name: "queryType")

  field(:query_args, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payloads,
    json_name: "queryArgs"
  )

  field(:header, 3, type: Temporal.Protos.Temporal.Api.Common.V1.Header)
end
