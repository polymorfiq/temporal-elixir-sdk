defmodule Temporal.Protos.Google.Api.HttpRule do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:pattern, 0)

  field(:selector, 1, type: :string)
  field(:get, 2, type: :string, oneof: 0)
  field(:put, 3, type: :string, oneof: 0)
  field(:post, 4, type: :string, oneof: 0)
  field(:delete, 5, type: :string, oneof: 0)
  field(:patch, 6, type: :string, oneof: 0)
  field(:custom, 8, type: Temporal.Protos.Google.Api.CustomHttpPattern, oneof: 0)
  field(:body, 7, type: :string)
  field(:response_body, 12, type: :string, json_name: "responseBody")

  field(:additional_bindings, 11,
    repeated: true,
    type: Temporal.Protos.Google.Api.HttpRule,
    json_name: "additionalBindings"
  )
end
