defmodule Temporal.Protos.Temporal.Api.Failure.V1.ApplicationFailureInfo do
  @moduledoc """
  Automatically generated module for ApplicationFailureInfo

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`category`** | `Temporal.Protos.Temporal.Api.Enums.V1.ApplicationErrorCategory` |  |
  | 3 | **`details`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` |  |
  | 4 | **`next_retry_delay`** | `Google.Protobuf.Duration` | next_retry_delay can be used by the client to override the activity |
  | 2 | **`non_retryable`** | `bool` |  |
  | 1 | **`type`** | `string` |  |

  ### Additional Notes

    * `next_retry_delay` (`Google.Protobuf.Duration`): next_retry_delay can be used by the client to override the activity
      retry interval calculated by the retry policy. Retry attempts will
      still be subject to the maximum retries limit and total time limit
      defined by the policy.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :type, 1, type: :string
  field :non_retryable, 2, type: :bool, json_name: "nonRetryable"
  field :details, 3, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
  field :next_retry_delay, 4, type: Google.Protobuf.Duration, json_name: "nextRetryDelay"

  field :category, 5,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ApplicationErrorCategory,
    enum: true
end
