defmodule Temporal.Protos.Temporal.Api.Enums.V1.QueryResultType do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:QUERY_RESULT_TYPE_UNSPECIFIED, 0)
  field(:QUERY_RESULT_TYPE_ANSWERED, 1)
  field(:QUERY_RESULT_TYPE_FAILED, 2)
end
