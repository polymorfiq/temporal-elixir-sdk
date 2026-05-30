defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.CreateScheduleResponse do
  @moduledoc """
  Automatically generated module for CreateScheduleResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`conflict_token`** | `bytes` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :conflict_token, 1, type: :bytes, json_name: "conflictToken"
end
