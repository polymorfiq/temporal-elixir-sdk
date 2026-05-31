defmodule Temporal.Protos.Temporal.Api.Worker.V1.WorkerPollerInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:current_pollers, 1, type: :int32, json_name: "currentPollers")

  field(:last_successful_poll_time, 2,
    type: Google.Protobuf.Timestamp,
    json_name: "lastSuccessfulPollTime"
  )

  field(:is_autoscaling, 3, type: :bool, json_name: "isAutoscaling")
end
