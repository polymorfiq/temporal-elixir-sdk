defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.CountActivityExecutionsRequest do
  @moduledoc """
  Automatically generated module for CountActivityExecutionsRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`namespace`** | `string` |  |
  | 2 | **`query`** | `string` | Visibility query, see https://docs.temporal.io/list-filter for the syntax. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :query, 2, type: :string
end
