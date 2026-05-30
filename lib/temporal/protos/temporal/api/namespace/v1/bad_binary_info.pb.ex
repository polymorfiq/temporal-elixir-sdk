defmodule Temporal.Protos.Temporal.Api.Namespace.V1.BadBinaryInfo do
  @moduledoc """
  Automatically generated module for BadBinaryInfo

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`create_time`** | `Google.Protobuf.Timestamp` |  |
  | 2 | **`operator`** | `string` |  |
  | 1 | **`reason`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :reason, 1, type: :string
  field :operator, 2, type: :string
  field :create_time, 3, type: Google.Protobuf.Timestamp, json_name: "createTime"
end
