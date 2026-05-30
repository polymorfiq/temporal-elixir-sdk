defmodule Temporal.Protos.Temporal.Api.Enums.V1.SuggestContinueAsNewReason do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :SUGGEST_CONTINUE_AS_NEW_REASON_UNSPECIFIED, 0
  field :SUGGEST_CONTINUE_AS_NEW_REASON_HISTORY_SIZE_TOO_LARGE, 1
  field :SUGGEST_CONTINUE_AS_NEW_REASON_TOO_MANY_HISTORY_EVENTS, 2
  field :SUGGEST_CONTINUE_AS_NEW_REASON_TOO_MANY_UPDATES, 3
end
