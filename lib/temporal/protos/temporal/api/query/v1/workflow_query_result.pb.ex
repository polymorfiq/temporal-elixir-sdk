defmodule Temporal.Protos.Temporal.Api.Query.V1.WorkflowQueryResult do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:result_type, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.QueryResultType,
    json_name: "resultType",
    enum: true
  )

  field(:answer, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)
  field(:error_message, 3, type: :string, json_name: "errorMessage")
  field(:failure, 4, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure)
end
