defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateActivityOptionsRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:activity, 0)

  field(:namespace, 1, type: :string)
  field(:execution, 2, type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution)
  field(:identity, 3, type: :string)

  field(:activity_options, 4,
    type: Temporal.Protos.Temporal.Api.Activity.V1.ActivityOptions,
    json_name: "activityOptions"
  )

  field(:update_mask, 5, type: Google.Protobuf.FieldMask, json_name: "updateMask")
  field(:id, 6, type: :string, oneof: 0)
  field(:type, 7, type: :string, oneof: 0)
  field(:match_all, 9, type: :bool, json_name: "matchAll", oneof: 0)
  field(:restore_original, 8, type: :bool, json_name: "restoreOriginal")
end
