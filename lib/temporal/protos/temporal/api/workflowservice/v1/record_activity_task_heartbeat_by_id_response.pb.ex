defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RecordActivityTaskHeartbeatByIdResponse do
  @moduledoc """
  Automatically generated module for RecordActivityTaskHeartbeatByIdResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`activity_paused`** | `bool` | Will be set to true if the activity is paused. |
  | 3 | **`activity_reset`** | `bool` | Will be set to true if the activity was reset. |
  | 1 | **`cancel_requested`** | `bool` | Will be set to true if the activity has been asked to cancel itself. The SDK should then |

  ### Additional Notes

    * `activity_reset` (`bool`): Will be set to true if the activity was reset.
      Applies only to the current run.
    * `cancel_requested` (`bool`): Will be set to true if the activity has been asked to cancel itself. The SDK should then
      notify the activity of cancellation if it is still running.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :cancel_requested, 1, type: :bool, json_name: "cancelRequested"
  field :activity_paused, 2, type: :bool, json_name: "activityPaused"
  field :activity_reset, 3, type: :bool, json_name: "activityReset"
end
