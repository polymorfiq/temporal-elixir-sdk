defmodule Temporal.Protos.Temporal.Api.Enums.V1.HistoryEventFilterType do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:HISTORY_EVENT_FILTER_TYPE_UNSPECIFIED, 0)
  field(:HISTORY_EVENT_FILTER_TYPE_ALL_EVENT, 1)
  field(:HISTORY_EVENT_FILTER_TYPE_CLOSE_EVENT, 2)
end
