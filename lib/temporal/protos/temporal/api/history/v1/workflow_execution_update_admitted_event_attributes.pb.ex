defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionUpdateAdmittedEventAttributes do
  @moduledoc """
  Automatically generated module for WorkflowExecutionUpdateAdmittedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`origin`** | `Temporal.Protos.Temporal.Api.Enums.V1.UpdateAdmittedEventOrigin` | An explanation of why this event was written to history. |
  | 1 | **`request`** | `Temporal.Protos.Temporal.Api.Update.V1.Request` | The update request associated with this event. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :request, 1, type: Temporal.Protos.Temporal.Api.Update.V1.Request

  field :origin, 2,
    type: Temporal.Protos.Temporal.Api.Enums.V1.UpdateAdmittedEventOrigin,
    enum: true
end
