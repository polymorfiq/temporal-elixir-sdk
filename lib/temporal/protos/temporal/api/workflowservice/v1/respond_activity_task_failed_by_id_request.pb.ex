defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondActivityTaskFailedByIdRequest do
  @moduledoc """
  Automatically generated module for RespondActivityTaskFailedByIdRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`activity_id`** | `string` | Id of the activity to fail |
  | 5 | **`failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | Detailed failure information |
  | 6 | **`identity`** | `string` | The identity of the worker/client |
  | 7 | **`last_heartbeat_details`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Additional details to be stored as last activity heartbeat |
  | 1 | **`namespace`** | `string` | Namespace of the workflow which scheduled this activity |
  | 8 | **`resource_id`** | `string` | Resource ID for routing. Contains "workflow:workflow_id" or "activity:activity_id" for standalone activities. |
  | 3 | **`run_id`** | `string` | For a workflow activity - the run ID of the workflow which scheduled this activity. |
  | 2 | **`workflow_id`** | `string` | Id of the workflow which scheduled this activity, leave empty to target a standalone activity |

  ### Additional Notes

    * `run_id` (`string`): For a workflow activity - the run ID of the workflow which scheduled this activity.
      For a standalone activity - the run ID of the activity.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :workflow_id, 2, type: :string, json_name: "workflowId"
  field :run_id, 3, type: :string, json_name: "runId"
  field :activity_id, 4, type: :string, json_name: "activityId"
  field :failure, 5, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure
  field :identity, 6, type: :string

  field :last_heartbeat_details, 7,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payloads,
    json_name: "lastHeartbeatDetails"

  field :resource_id, 8, type: :string, json_name: "resourceId"
end
