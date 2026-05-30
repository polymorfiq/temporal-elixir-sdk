defmodule Temporal.Protos.Temporal.Api.Enums.V1.PendingActivityState do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :PENDING_ACTIVITY_STATE_UNSPECIFIED, 0
  field :PENDING_ACTIVITY_STATE_SCHEDULED, 1
  field :PENDING_ACTIVITY_STATE_STARTED, 2
  field :PENDING_ACTIVITY_STATE_CANCEL_REQUESTED, 3
  field :PENDING_ACTIVITY_STATE_PAUSED, 4
  field :PENDING_ACTIVITY_STATE_PAUSE_REQUESTED, 5
end
