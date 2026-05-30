defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerScalingDecision do
  @moduledoc """
  Attached to task responses to give hints to the SDK about how it may adjust its number of
  pollers.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`poll_request_delta_suggestion`** | `int32` | How many poll requests to suggest should be added or removed, if any. As of now, server only |

  ### Additional Notes

    * `poll_request_delta_suggestion` (`int32`): How many poll requests to suggest should be added or removed, if any. As of now, server only
      scales up or down by 1. However, SDKs should allow for other values (while staying within
      defined min/max).

      The SDK is free to ignore this suggestion, EX: making more polls would not make sense because
      all slots are already occupied.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :poll_request_delta_suggestion, 1, type: :int32, json_name: "pollRequestDeltaSuggestion"
end
