defmodule Temporal.Protos.Temporal.Api.Workflow.V1.PostResetOperation.SignalWorkflow do
  @moduledoc """
  PostResetOperation represents an operation to be performed on the new workflow execution after a workflow reset.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`header`** | `Temporal.Protos.Temporal.Api.Common.V1.Header` |  |
  | 2 | **`input`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` |  |
  | 4 | **`links`** | `Temporal.Protos.Temporal.Api.Common.V1.Link` |  |
  | 1 | **`signal_name`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :signal_name, 1, type: :string, json_name: "signalName"
  field :input, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
  field :header, 3, type: Temporal.Protos.Temporal.Api.Common.V1.Header
  field :links, 4, repeated: true, type: Temporal.Protos.Temporal.Api.Common.V1.Link
end
