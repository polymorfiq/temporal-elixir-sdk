defmodule Temporal.Protos.Temporal.Api.Errordetails.V1.NamespaceUnavailableFailure do
  @moduledoc """
  NamespaceUnavailableFailure is returned by the service when a request addresses a namespace that is unavailable. For
  example, when a namespace is in the process of failing over between clusters.
  This is a transient error that should be automatically retried by clients.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`namespace`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
end
