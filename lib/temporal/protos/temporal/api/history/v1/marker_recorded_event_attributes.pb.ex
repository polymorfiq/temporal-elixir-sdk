defmodule Temporal.Protos.Temporal.Api.History.V1.MarkerRecordedEventAttributes do
  @moduledoc """
  Automatically generated module for MarkerRecordedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`details`** | `Temporal.Protos.Temporal.Api.History.V1.MarkerRecordedEventAttributes.DetailsEntry` | Serialized information recorded in the marker |
  | 5 | **`failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | Some uses of markers, like a local activity, could "fail". If they did that is recorded here. |
  | 4 | **`header`** | `Temporal.Protos.Temporal.Api.Common.V1.Header` |  |
  | 1 | **`marker_name`** | `string` | Workers use this to identify the "types" of various markers. Ex: Local activity, side effect. |
  | 3 | **`workflow_task_completed_event_id`** | `int64` | The `WORKFLOW_TASK_COMPLETED` event which this command was reported with |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :marker_name, 1, type: :string, json_name: "markerName"

  field :details, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.History.V1.MarkerRecordedEventAttributes.DetailsEntry,
    map: true

  field :workflow_task_completed_event_id, 3,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"

  field :header, 4, type: Temporal.Protos.Temporal.Api.Common.V1.Header
  field :failure, 5, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure
end
