defmodule Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy do
  @moduledoc """
  How retries ought to be handled, usable by both workflows and activities

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`backoff_coefficient`** | `double` | Coefficient used to calculate the next retry interval. |
  | 1 | **`initial_interval`** | `Google.Protobuf.Duration` | Interval of the first retry. If retryBackoffCoefficient is 1.0 then it is used for all retries. |
  | 4 | **`maximum_attempts`** | `int32` | Maximum number of attempts. When exceeded the retries stop even if not expired yet. |
  | 3 | **`maximum_interval`** | `Google.Protobuf.Duration` | Maximum interval between retries. Exponential backoff leads to interval increase. |
  | 5 | **`non_retryable_error_types`** | `string` | Non-Retryable errors types. Will stop retrying if the error type matches this list. Note that |

  ### Additional Notes

    * `backoff_coefficient` (`double`): Coefficient used to calculate the next retry interval.
      The next retry interval is previous interval multiplied by the coefficient.
      Must be 1 or larger.
    * `maximum_attempts` (`int32`): Maximum number of attempts. When exceeded the retries stop even if not expired yet.
      1 disables retries. 0 means unlimited (up to the timeouts)
    * `maximum_interval` (`Google.Protobuf.Duration`): Maximum interval between retries. Exponential backoff leads to interval increase.
      This value is the cap of the increase. Default is 100x of the initial interval.
    * `non_retryable_error_types` (`string`): Non-Retryable errors types. Will stop retrying if the error type matches this list. Note that
      this is not a substring match, the error *type* (not message) must match exactly.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :initial_interval, 1, type: Google.Protobuf.Duration, json_name: "initialInterval"
  field :backoff_coefficient, 2, type: :double, json_name: "backoffCoefficient"
  field :maximum_interval, 3, type: Google.Protobuf.Duration, json_name: "maximumInterval"
  field :maximum_attempts, 4, type: :int32, json_name: "maximumAttempts"

  field :non_retryable_error_types, 5,
    repeated: true,
    type: :string,
    json_name: "nonRetryableErrorTypes"
end
