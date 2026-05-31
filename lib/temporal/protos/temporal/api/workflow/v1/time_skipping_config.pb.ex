defmodule Temporal.Protos.Temporal.Api.Workflow.V1.TimeSkippingConfig do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:bound, 0)

  field(:enabled, 1, type: :bool)

  field(:max_skipped_duration, 4,
    type: Google.Protobuf.Duration,
    json_name: "maxSkippedDuration",
    oneof: 0
  )

  field(:max_elapsed_duration, 5,
    type: Google.Protobuf.Duration,
    json_name: "maxElapsedDuration",
    oneof: 0
  )
end
