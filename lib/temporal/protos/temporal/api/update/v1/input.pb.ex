defmodule Temporal.Protos.Temporal.Api.Update.V1.Input do
  @moduledoc """
  Automatically generated module for Input

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`args`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | The arguments to pass to the named Update handler. |
  | 1 | **`header`** | `Temporal.Protos.Temporal.Api.Common.V1.Header` | Headers that are passed with the Update from the requesting entity. |
  | 2 | **`name`** | `string` | The name of the Update handler to invoke on the target Workflow. |

  ### Additional Notes

    * `header` (`Temporal.Protos.Temporal.Api.Common.V1.Header`): Headers that are passed with the Update from the requesting entity.
      These can include things like auth or tracing tokens.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :header, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Header
  field :name, 2, type: :string
  field :args, 3, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
end
