defmodule Temporal.Protos.Temporal.Api.Nexus.V1.EndpointSpec do
  @moduledoc """
  Contains mutable fields for an Endpoint.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`description`** | `Temporal.Protos.Temporal.Api.Common.V1.Payload` | Markdown description serialized as a single JSON string. |
  | 1 | **`name`** | `string` | Endpoint name, unique for this cluster. Must match `[a-zA-Z_][a-zA-Z0-9_]*`. |
  | 3 | **`target`** | `Temporal.Protos.Temporal.Api.Nexus.V1.EndpointTarget` | Target to route requests to. |

  ### Additional Notes

    * `description` (`Temporal.Protos.Temporal.Api.Common.V1.Payload`): Markdown description serialized as a single JSON string.
      If the Payload is encrypted, the UI and CLI may decrypt with the configured codec server endpoint.
      By default, the server enforces a limit of 20,000 bytes for this entire payload.
    * `name` (`string`): Endpoint name, unique for this cluster. Must match `[a-zA-Z_][a-zA-Z0-9_]*`.
      Renaming an endpoint breaks all workflow callers that reference this endpoint, causing operations to fail.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :name, 1, type: :string
  field :description, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payload
  field :target, 3, type: Temporal.Protos.Temporal.Api.Nexus.V1.EndpointTarget
end
