defmodule Temporal.Protos.Temporal.Api.Nexus.V1.Failure do
  @moduledoc """
  A general purpose failure message.
  See: https://github.com/nexus-rpc/api/blob/main/SPEC.md#failure

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`cause`** | `Temporal.Protos.Temporal.Api.Nexus.V1.Failure` |  |
  | 3 | **`details`** | `bytes` | UTF-8 encoded JSON serializable details. |
  | 1 | **`message`** | `string` |  |
  | 2 | **`metadata`** | `Temporal.Protos.Temporal.Api.Nexus.V1.Failure.MetadataEntry` |  |
  | 4 | **`stack_trace`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :message, 1, type: :string
  field :stack_trace, 4, type: :string, json_name: "stackTrace"

  field :metadata, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.Failure.MetadataEntry,
    map: true

  field :details, 3, type: :bytes
  field :cause, 5, type: Temporal.Protos.Temporal.Api.Nexus.V1.Failure
end
