defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeActivityExecutionResponse do
  @moduledoc """
  Automatically generated module for DescribeActivityExecutionResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 6 | **`callbacks`** | `Temporal.Protos.Temporal.Api.Activity.V1.CallbackInfo` | Callbacks attached to this activity execution and their current state. |
  | 2 | **`info`** | `Temporal.Protos.Temporal.Api.Activity.V1.ActivityExecutionInfo` | Information about the activity execution. |
  | 3 | **`input`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Serialized activity input, passed as arguments to the activity function. |
  | 5 | **`long_poll_token`** | `bytes` | Token for follow-on long-poll requests. Absent only if the activity is complete. |
  | 4 | **`outcome`** | `Temporal.Protos.Temporal.Api.Activity.V1.ActivityExecutionOutcome` | Only set if the activity is completed and include_outcome was true in the request. |
  | 1 | **`run_id`** | `string` | The run ID of the activity, useful when run_id was not specified in the request. |

  ### Additional Notes

    * `input` (`Temporal.Protos.Temporal.Api.Common.V1.Payloads`): Serialized activity input, passed as arguments to the activity function.
      Only set if include_input was true in the request.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :run_id, 1, type: :string, json_name: "runId"
  field :info, 2, type: Temporal.Protos.Temporal.Api.Activity.V1.ActivityExecutionInfo
  field :input, 3, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
  field :outcome, 4, type: Temporal.Protos.Temporal.Api.Activity.V1.ActivityExecutionOutcome
  field :long_poll_token, 5, type: :bytes, json_name: "longPollToken"
  field :callbacks, 6, repeated: true, type: Temporal.Protos.Temporal.Api.Activity.V1.CallbackInfo
end
