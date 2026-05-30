defmodule Temporal.Protos.Temporal.Api.Update.V1.Request do
  @moduledoc """
  The client request that triggers a Workflow Update.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`completion_callbacks`** | `Temporal.Protos.Temporal.Api.Common.V1.Callback` | Callbacks to be called by the server when this update reaches a terminal state. |
  | 2 | **`input`** | `Temporal.Protos.Temporal.Api.Update.V1.Input` |  |
  | 5 | **`links`** | `Temporal.Protos.Temporal.Api.Common.V1.Link` | Links to be associated with this update. |
  | 1 | **`meta`** | `Temporal.Protos.Temporal.Api.Update.V1.Meta` |  |
  | 3 | **`request_id`** | `string` | The request ID of the request. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :meta, 1, type: Temporal.Protos.Temporal.Api.Update.V1.Meta
  field :input, 2, type: Temporal.Protos.Temporal.Api.Update.V1.Input
  field :request_id, 3, type: :string, json_name: "requestId"

  field :completion_callbacks, 4,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.Callback,
    json_name: "completionCallbacks"

  field :links, 5, repeated: true, type: Temporal.Protos.Temporal.Api.Common.V1.Link
end
