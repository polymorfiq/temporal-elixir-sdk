defmodule Temporal.Protos.Temporal.Api.Schedule.V1.SchedulePolicies do
  @moduledoc """
  Automatically generated module for SchedulePolicies

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`catchup_window`** | `Google.Protobuf.Duration` | Policy for catchups: |
  | 4 | **`keep_original_workflow_id`** | `bool` | If true, and the action would start a workflow, a timestamp will not be |
  | 1 | **`overlap_policy`** | `Temporal.Protos.Temporal.Api.Enums.V1.ScheduleOverlapPolicy` | Policy for overlaps. |
  | 3 | **`pause_on_failure`** | `bool` | If true, and a workflow run fails or times out, turn on "paused". |

  ### Additional Notes

    * `catchup_window` (`Google.Protobuf.Duration`): Policy for catchups:
      If the Temporal server misses an action due to one or more components
      being down, and comes back up, the action will be run if the scheduled
      time is within this window from the current time.
      This value defaults to one year, and can't be less than 10 seconds.
    * `keep_original_workflow_id` (`bool`): If true, and the action would start a workflow, a timestamp will not be
      appended to the scheduled workflow id.
    * `overlap_policy` (`Temporal.Protos.Temporal.Api.Enums.V1.ScheduleOverlapPolicy`): Policy for overlaps.
      Note that this can be changed after a schedule has taken some actions,
      and some changes might produce unintuitive results. In general, the later
      policy overrides the earlier policy.
    * `pause_on_failure` (`bool`): If true, and a workflow run fails or times out, turn on "paused".
      This applies after retry policies: the full chain of retries must fail to
      trigger a pause here.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :overlap_policy, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ScheduleOverlapPolicy,
    json_name: "overlapPolicy",
    enum: true

  field :catchup_window, 2, type: Google.Protobuf.Duration, json_name: "catchupWindow"
  field :pause_on_failure, 3, type: :bool, json_name: "pauseOnFailure"
  field :keep_original_workflow_id, 4, type: :bool, json_name: "keepOriginalWorkflowId"
end
