defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowTaskStartedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId")
  field(:identity, 2, type: :string)
  field(:request_id, 3, type: :string, json_name: "requestId")
  field(:suggest_continue_as_new, 4, type: :bool, json_name: "suggestContinueAsNew")

  field(:suggest_continue_as_new_reasons, 8,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Enums.V1.SuggestContinueAsNewReason,
    json_name: "suggestContinueAsNewReasons",
    enum: true
  )

  field(:target_worker_deployment_version_changed, 9,
    type: :bool,
    json_name: "targetWorkerDeploymentVersionChanged"
  )

  field(:history_size_bytes, 5, type: :int64, json_name: "historySizeBytes")

  field(:worker_version, 6,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "workerVersion",
    deprecated: true
  )

  field(:build_id_redirect_counter, 7,
    type: :int64,
    json_name: "buildIdRedirectCounter",
    deprecated: true
  )
end
