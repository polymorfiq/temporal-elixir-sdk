defmodule Temporal.Protos.Temporal.Api.Deployment.V1.Deployment do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:series_name, 1, type: :string, json_name: "seriesName")
  field(:build_id, 2, type: :string, json_name: "buildId")
end
