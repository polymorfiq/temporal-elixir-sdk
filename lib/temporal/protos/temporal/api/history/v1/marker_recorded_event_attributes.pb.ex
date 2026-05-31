defmodule Temporal.Protos.Temporal.Api.History.V1.MarkerRecordedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:marker_name, 1, type: :string, json_name: "markerName")

  field(:details, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.History.V1.MarkerRecordedEventAttributes.DetailsEntry,
    map: true
  )

  field(:workflow_task_completed_event_id, 3,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"
  )

  field(:header, 4, type: Temporal.Protos.Temporal.Api.Common.V1.Header)
  field(:failure, 5, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure)
end
