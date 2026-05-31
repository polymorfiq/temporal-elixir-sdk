defmodule Temporal.Protos.Temporal.Api.Filter.V1.StartTimeFilter do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:earliest_time, 1, type: Google.Protobuf.Timestamp, json_name: "earliestTime")
  field(:latest_time, 2, type: Google.Protobuf.Timestamp, json_name: "latestTime")
end
