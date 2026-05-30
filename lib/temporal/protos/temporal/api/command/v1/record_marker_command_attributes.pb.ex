defmodule Temporal.Protos.Temporal.Api.Command.V1.RecordMarkerCommandAttributes do
  @moduledoc """
  Automatically generated module for RecordMarkerCommandAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`details`** | `Temporal.Protos.Temporal.Api.Command.V1.RecordMarkerCommandAttributes.DetailsEntry` |  |
  | 4 | **`failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` |  |
  | 3 | **`header`** | `Temporal.Protos.Temporal.Api.Common.V1.Header` |  |
  | 1 | **`marker_name`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :marker_name, 1, type: :string, json_name: "markerName"

  field :details, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Command.V1.RecordMarkerCommandAttributes.DetailsEntry,
    map: true

  field :header, 3, type: Temporal.Protos.Temporal.Api.Common.V1.Header
  field :failure, 4, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure
end
