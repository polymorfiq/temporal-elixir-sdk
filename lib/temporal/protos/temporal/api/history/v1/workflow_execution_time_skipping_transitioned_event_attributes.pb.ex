defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionTimeSkippingTransitionedEventAttributes do
  @moduledoc """
  Attributes for an event indicating that time skipping state changed for a workflow execution,
  either time was advanced or time skipping was disabled automatically due to a bound being reached.
  The worker_may_ignore field in HistoryEvent should always be set true for this event.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`disabled_after_bound`** | `bool` | when true, time skipping was disabled automatically due to a bound being reached. |
  | 1 | **`target_time`** | `Google.Protobuf.Timestamp` | The virtual time after time skipping was applied. |
  | 3 | **`wall_clock_time`** | `Google.Protobuf.Timestamp` | The wall-clock time when the time-skipping state changed event was generated. |

  ### Additional Notes

    * `disabled_after_bound` (`bool`): when true, time skipping was disabled automatically due to a bound being reached.
      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "after" is used to indicate temporal ordering. --)

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :target_time, 1, type: Google.Protobuf.Timestamp, json_name: "targetTime"
  field :disabled_after_bound, 2, type: :bool, json_name: "disabledAfterBound"
  field :wall_clock_time, 3, type: Google.Protobuf.Timestamp, json_name: "wallClockTime"
end
