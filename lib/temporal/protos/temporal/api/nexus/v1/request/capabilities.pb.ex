defmodule Temporal.Protos.Temporal.Api.Nexus.V1.Request.Capabilities do
  @moduledoc """
  A Nexus request.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`temporal_failure_responses`** | `bool` | Headers extracted from the original request in the Temporal frontend. |

  ### Additional Notes

    * `temporal_failure_responses` (`bool`): Headers extracted from the original request in the Temporal frontend.
      When using Nexus over HTTP, this includes the request's HTTP headers ignoring multiple values.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :temporal_failure_responses, 1, type: :bool, json_name: "temporalFailureResponses"
end
