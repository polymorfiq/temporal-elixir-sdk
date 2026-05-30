defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.ListNexusEndpointsResponse do
  @moduledoc """
  Automatically generated module for ListNexusEndpointsResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`endpoints`** | `Temporal.Protos.Temporal.Api.Nexus.V1.Endpoint` |  |
  | 1 | **`next_page_token`** | `bytes` | Token for getting the next page. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :next_page_token, 1, type: :bytes, json_name: "nextPageToken"
  field :endpoints, 2, repeated: true, type: Temporal.Protos.Temporal.Api.Nexus.V1.Endpoint
end
