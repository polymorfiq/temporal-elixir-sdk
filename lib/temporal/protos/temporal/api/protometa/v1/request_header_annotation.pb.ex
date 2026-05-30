defmodule Temporal.Protos.Temporal.Api.Protometa.V1.RequestHeaderAnnotation do
  @moduledoc """
  RequestHeaderAnnotation allows specifying that field values from a request
  should be propagated as outbound headers.

  The value field supports template interpolation where field paths enclosed
  in braces will be replaced with the actual field values from the request.
  For example:
    value: "{workflow_execution.workflow_id}"
    value: "workflow-{workflow_execution.workflow_id}"
    value: "{namespace}/{workflow_execution.workflow_id}"

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`header`** | `string` | The name of the header to set (e.g., "temporal-resource-id") |
  | 2 | **`value`** | `string` | A template string that may contain field paths in braces. |

  ### Additional Notes

    * `value` (`string`): A template string that may contain field paths in braces.
      Field paths use dot notation to traverse nested messages.
      Example: "{workflow_execution.workflow_id}"

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :header, 1, type: :string
  field :value, 2, type: :string
end
