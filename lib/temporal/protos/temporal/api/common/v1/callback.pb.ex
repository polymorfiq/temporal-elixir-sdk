defmodule Temporal.Protos.Temporal.Api.Common.V1.Callback do
  @moduledoc """
  Callback to attach to various events in the system, e.g. workflow run completion.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`internal`** | `Temporal.Protos.Temporal.Api.Common.V1.Callback.Internal` |  |
  | 100 | **`links`** | `Temporal.Protos.Temporal.Api.Common.V1.Link` | Links associated with the callback. It can be used to link to underlying resources of the |
  | 2 | **`nexus`** | `Temporal.Protos.Temporal.Api.Common.V1.Callback.Nexus` |  |

  ### Additional Notes

    * `links` (`Temporal.Protos.Temporal.Api.Common.V1.Link`): Links associated with the callback. It can be used to link to underlying resources of the
      callback.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :variant, 0

  field :nexus, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Callback.Nexus, oneof: 0
  field :internal, 3, type: Temporal.Protos.Temporal.Api.Common.V1.Callback.Internal, oneof: 0
  field :links, 100, repeated: true, type: Temporal.Protos.Temporal.Api.Common.V1.Link
end
