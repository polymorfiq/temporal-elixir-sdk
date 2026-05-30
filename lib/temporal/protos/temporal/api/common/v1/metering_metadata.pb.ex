defmodule Temporal.Protos.Temporal.Api.Common.V1.MeteringMetadata do
  @moduledoc """
  Metadata relevant for metering purposes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 13 | **`nonfirst_local_activity_execution_attempts`** | `uint32` | Count of local activities which have begun an execution attempt during this workflow task, |

  ### Additional Notes

    * `nonfirst_local_activity_execution_attempts` (`uint32`): Count of local activities which have begun an execution attempt during this workflow task,
      and whose first attempt occurred in some previous task. This is used for metering
      purposes, and does not affect workflow state.

      (-- api-linter: core::0141::forbidden-types=disabled
          aip.dev/not-precedent: Negative values make no sense to represent. --)

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :nonfirst_local_activity_execution_attempts, 13,
    type: :uint32,
    json_name: "nonfirstLocalActivityExecutionAttempts"
end
