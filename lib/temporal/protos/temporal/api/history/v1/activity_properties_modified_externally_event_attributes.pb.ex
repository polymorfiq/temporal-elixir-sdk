defmodule Temporal.Protos.Temporal.Api.History.V1.ActivityPropertiesModifiedExternallyEventAttributes do
  @moduledoc """
  Automatically generated module for ActivityPropertiesModifiedExternallyEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`new_retry_policy`** | `Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy` | If set, update the retry policy of the activity, replacing it with the specified one. |
  | 1 | **`scheduled_event_id`** | `int64` | The id of the `ACTIVITY_TASK_SCHEDULED` event this modification corresponds to. |

  ### Additional Notes

    * `new_retry_policy` (`Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy`): If set, update the retry policy of the activity, replacing it with the specified one.
      The number of attempts at the activity is preserved.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId"

  field :new_retry_policy, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy,
    json_name: "newRetryPolicy"
end
