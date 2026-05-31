defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.GetSystemInfoResponse.Capabilities do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:signal_and_query_header, 1, type: :bool, json_name: "signalAndQueryHeader")

  field(:internal_error_differentiation, 2,
    type: :bool,
    json_name: "internalErrorDifferentiation"
  )

  field(:activity_failure_include_heartbeat, 3,
    type: :bool,
    json_name: "activityFailureIncludeHeartbeat"
  )

  field(:supports_schedules, 4, type: :bool, json_name: "supportsSchedules")
  field(:encoded_failure_attributes, 5, type: :bool, json_name: "encodedFailureAttributes")
  field(:build_id_based_versioning, 6, type: :bool, json_name: "buildIdBasedVersioning")
  field(:upsert_memo, 7, type: :bool, json_name: "upsertMemo")
  field(:eager_workflow_start, 8, type: :bool, json_name: "eagerWorkflowStart")
  field(:sdk_metadata, 9, type: :bool, json_name: "sdkMetadata")

  field(:count_group_by_execution_status, 10,
    type: :bool,
    json_name: "countGroupByExecutionStatus"
  )

  field(:nexus, 11, type: :bool)
  field(:server_scaled_deployments, 12, type: :bool, json_name: "serverScaledDeployments")
end
