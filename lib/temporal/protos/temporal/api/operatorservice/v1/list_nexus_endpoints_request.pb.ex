defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.ListNexusEndpointsRequest do
  @moduledoc """
  Automatically generated module for ListNexusEndpointsRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`name`** | `string` | Name of the incoming endpoint to filter on - optional. Specifying this will result in zero or one results. |
  | 2 | **`next_page_token`** | `bytes` | To get the next page, pass in `ListNexusEndpointsResponse.next_page_token` from the previous page's |
  | 1 | **`page_size`** | `int32` |  |

  ### Additional Notes

    * `name` (`string`): Name of the incoming endpoint to filter on - optional. Specifying this will result in zero or one results.
      (-- api-linter: core::203::field-behavior-required=disabled
          aip.dev/not-precedent: Not following linter rules. --)
    * `next_page_token` (`bytes`): To get the next page, pass in `ListNexusEndpointsResponse.next_page_token` from the previous page's
      response, the token will be empty if there's no other page.
      Note: the last page may be empty if the total number of endpoints registered is a multiple of the page size.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :page_size, 1, type: :int32, json_name: "pageSize"
  field :next_page_token, 2, type: :bytes, json_name: "nextPageToken"
  field :name, 3, type: :string
end
