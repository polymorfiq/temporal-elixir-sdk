defmodule Temporal.Protos.Google.Api.Http do
  @moduledoc """
  Defines the HTTP configuration for an API service. It contains a list of
  [HttpRule][google.api.HttpRule], each specifying the mapping of an RPC method
  to one or more HTTP REST API methods.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`fully_decode_reserved_expansion`** | `bool` | When set to true, URL path parameters will be fully URI-decoded except in |
  | 1 | **`rules`** | `Temporal.Protos.Google.Api.HttpRule` | A list of HTTP configuration rules that apply to individual API methods. |

  ### Additional Notes

    * `fully_decode_reserved_expansion` (`bool`): When set to true, URL path parameters will be fully URI-decoded except in
      cases of single segment matches in reserved expansion, where "%2F" will be
      left encoded.

      The default behavior is to not decode RFC 6570 reserved characters in multi
      segment matches.
    * `rules` (`Temporal.Protos.Google.Api.HttpRule`): A list of HTTP configuration rules that apply to individual API methods.

      **NOTE:** All service configuration rules follow "last one wins" order.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :rules, 1, repeated: true, type: Temporal.Protos.Google.Api.HttpRule

  field :fully_decode_reserved_expansion, 2,
    type: :bool,
    json_name: "fullyDecodeReservedExpansion"
end
