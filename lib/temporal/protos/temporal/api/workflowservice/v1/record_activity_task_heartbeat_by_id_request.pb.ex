defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RecordActivityTaskHeartbeatByIdRequest do
  @moduledoc """
  Automatically generated module for RecordActivityTaskHeartbeatByIdRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`activity_id`** | `string` | Id of the activity we're heartbeating |
  | 5 | **`details`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Arbitrary data, of which the most recent call is kept, to store for this activity |
  | 6 | **`identity`** | `string` | The identity of the worker/client |
  | 1 | **`namespace`** | `string` | Namespace of the workflow which scheduled this activity |
  | 7 | **`resource_id`** | `string` | Resource ID for routing. Contains "workflow:workflow_id" or "activity:activity_id" for standalone activities. |
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
  field :details, 5, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
  field :identity, 6, type: :string
  field :resource_id, 7, type: :string, json_name: "resourceId"
end
