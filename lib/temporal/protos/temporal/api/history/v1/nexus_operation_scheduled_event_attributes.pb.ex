defmodule Temporal.Protos.Temporal.Api.History.V1.NexusOperationScheduledEventAttributes do
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
      Temporal.Protos.Temporal.Api.History.V1.NexusOperationScheduledEventAttributes.NexusHeaderEntry,
    json_name: "nexusHeader",
    map: true
  )

  field(:workflow_task_completed_event_id, 7,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"
  )

  field(:request_id, 8, type: :string, json_name: "requestId")
  field(:endpoint_id, 9, type: :string, json_name: "endpointId")

  field(:schedule_to_start_timeout, 10,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToStartTimeout"
  )

  field(:start_to_close_timeout, 11,
    type: Google.Protobuf.Duration,
    json_name: "startToCloseTimeout"
  )
end
