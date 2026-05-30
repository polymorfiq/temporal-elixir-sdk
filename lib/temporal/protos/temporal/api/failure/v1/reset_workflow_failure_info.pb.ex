defmodule Temporal.Protos.Temporal.Api.Failure.V1.ResetWorkflowFailureInfo do
  @moduledoc """
  Automatically generated module for ResetWorkflowFailureInfo

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`last_heartbeat_details`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :last_heartbeat_details, 1,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payloads,
    json_name: "lastHeartbeatDetails"
end
