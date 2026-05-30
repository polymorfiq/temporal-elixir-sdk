defmodule Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceInfo.Limits do
  @moduledoc """
  Automatically generated module for Limits

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`blob_size_limit_error`** | `int64` |  |
  | 2 | **`memo_size_limit_error`** | `int64` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :blob_size_limit_error, 1, type: :int64, json_name: "blobSizeLimitError"
  field :memo_size_limit_error, 2, type: :int64, json_name: "memoSizeLimitError"
end
