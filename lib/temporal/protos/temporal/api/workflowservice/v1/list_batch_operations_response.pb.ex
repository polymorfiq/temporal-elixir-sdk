defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListBatchOperationsResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:operation_info, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationInfo,
    json_name: "operationInfo"
  )

  field(:next_page_token, 2, type: :bytes, json_name: "nextPageToken")
end
