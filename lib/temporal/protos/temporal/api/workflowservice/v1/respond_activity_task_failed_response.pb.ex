defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondActivityTaskFailedResponse do
  @moduledoc """
  Automatically generated module for RespondActivityTaskFailedResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`failures`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | Server validation failures could include |

  ### Additional Notes

    * `failures` (`Temporal.Protos.Temporal.Api.Failure.V1.Failure`): Server validation failures could include
      last_heartbeat_details payload is too large, request failure is too large

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :failures, 1, repeated: true, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure
end
