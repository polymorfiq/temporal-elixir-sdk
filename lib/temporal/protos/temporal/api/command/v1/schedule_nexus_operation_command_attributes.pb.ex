defmodule Temporal.Protos.Temporal.Api.Command.V1.ScheduleNexusOperationCommandAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:endpoint, 1, type: :string)
  field(:service, 2, type: :string)
  field(:operation, 3, type: :string)
  field(:input, 4, type: Temporal.Protos.Temporal.Api.Common.V1.Payload)

  field(:schedule_to_close_timeout, 5,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToCloseTimeout"
  )

  field(:nexus_header, 6,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Command.V1.ScheduleNexusOperationCommandAttributes.NexusHeaderEntry,
    json_name: "nexusHeader",
    map: true
  )

  field(:schedule_to_start_timeout, 7,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToStartTimeout"
  )

  field(:start_to_close_timeout, 8,
    type: Google.Protobuf.Duration,
    json_name: "startToCloseTimeout"
  )
end
