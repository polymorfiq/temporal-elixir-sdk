defmodule Temporal.Protos.Temporal.Api.Nexus.V1.Request.HeaderEntry do
  @moduledoc """
  A Nexus request.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` | Headers extracted from the original request in the Temporal frontend. |
  | 2 | **`value`** | `string` | The timestamp when the request was scheduled in the frontend. |

  ### Additional Notes

    * `key` (`string`): Headers extracted from the original request in the Temporal frontend.
      When using Nexus over HTTP, this includes the request's HTTP headers ignoring multiple values.
    * `value` (`string`): The timestamp when the request was scheduled in the frontend.
      (-- api-linter: core::0142::time-field-names=disabled
          aip.dev/not-precedent: Not following linter rules. --)

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: :string
end
