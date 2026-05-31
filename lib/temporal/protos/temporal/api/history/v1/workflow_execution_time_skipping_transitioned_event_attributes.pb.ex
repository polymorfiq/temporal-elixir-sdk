defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionTimeSkippingTransitionedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:target_time, 1, type: Google.Protobuf.Timestamp, json_name: "targetTime")
  field(:disabled_after_bound, 2, type: :bool, json_name: "disabledAfterBound")
  field(:wall_clock_time, 3, type: Google.Protobuf.Timestamp, json_name: "wallClockTime")
end
