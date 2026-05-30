defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeNamespaceRequest do
  @moduledoc """
  Automatically generated module for DescribeNamespaceRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`id`** | `string` |  |
  | 1 | **`namespace`** | `string` |  |
  | 3 | **`weak_consistency`** | `bool` | If true, the server may serve the response from an eventually-consistent |

  ### Additional Notes

    * `weak_consistency` (`bool`): If true, the server may serve the response from an eventually-consistent
      source instead of reading through to persistence. Defaults to false,
      which preserves read-after-write consistency. SDKs should set this when
      fetching namespace capabilities on worker/client startup.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :id, 2, type: :string
  field :weak_consistency, 3, type: :bool, json_name: "weakConsistency"
end
