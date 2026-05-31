defmodule Temporal.Protos.Temporal.Api.Common.V1.Priority do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:priority_key, 1, type: :int32, json_name: "priorityKey")
  field(:fairness_key, 2, type: :string, json_name: "fairnessKey")
  field(:fairness_weight, 3, type: :float, json_name: "fairnessWeight")
end
