defmodule Temporal.Protos.Temporal.Api.Enums.V1.ResetType do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :RESET_TYPE_UNSPECIFIED, 0
  field :RESET_TYPE_FIRST_WORKFLOW_TASK, 1
  field :RESET_TYPE_LAST_WORKFLOW_TASK, 2
end
