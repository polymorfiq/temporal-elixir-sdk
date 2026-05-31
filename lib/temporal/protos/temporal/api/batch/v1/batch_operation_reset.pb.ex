defmodule Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationReset do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:identity, 3, type: :string)
  field(:options, 4, type: Temporal.Protos.Temporal.Api.Common.V1.ResetOptions)

  field(:reset_type, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ResetType,
    json_name: "resetType",
    enum: true,
    deprecated: true
  )

  field(:reset_reapply_type, 2,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ResetReapplyType,
    json_name: "resetReapplyType",
    enum: true,
    deprecated: true
  )

  field(:post_reset_operations, 5,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.PostResetOperation,
    json_name: "postResetOperations"
  )
end
