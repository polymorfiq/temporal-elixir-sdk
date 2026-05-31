defmodule Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationUpdateActivityOptions do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:activity, 0)

  field(:identity, 1, type: :string)
  field(:type, 2, type: :string, oneof: 0)
  field(:match_all, 3, type: :bool, json_name: "matchAll", oneof: 0)

  field(:activity_options, 4,
    type: Temporal.Protos.Temporal.Api.Activity.V1.ActivityOptions,
    json_name: "activityOptions"
  )

  field(:update_mask, 5, type: Google.Protobuf.FieldMask, json_name: "updateMask")
  field(:restore_original, 6, type: :bool, json_name: "restoreOriginal")
end
