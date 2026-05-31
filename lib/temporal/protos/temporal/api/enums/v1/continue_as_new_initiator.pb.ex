defmodule Temporal.Protos.Temporal.Api.Enums.V1.ContinueAsNewInitiator do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:CONTINUE_AS_NEW_INITIATOR_UNSPECIFIED, 0)
  field(:CONTINUE_AS_NEW_INITIATOR_WORKFLOW, 1)
  field(:CONTINUE_AS_NEW_INITIATOR_RETRY, 2)
  field(:CONTINUE_AS_NEW_INITIATOR_CRON_SCHEDULE, 3)
end
