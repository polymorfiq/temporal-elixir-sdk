defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateActivityExecutionOptionsRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:workflow_id, 2, type: :string, json_name: "workflowId")
  field(:activity_id, 3, type: :string, json_name: "activityId")
  field(:run_id, 4, type: :string, json_name: "runId")
  field(:identity, 5, type: :string)

  field(:activity_options, 6,
    type: Temporal.Protos.Temporal.Api.Activity.V1.ActivityOptions,
    json_name: "activityOptions"
  )

  field(:update_mask, 7, type: Google.Protobuf.FieldMask, json_name: "updateMask")
  field(:restore_original, 8, type: :bool, json_name: "restoreOriginal")
  field(:resource_id, 9, type: :string, json_name: "resourceId")
end
