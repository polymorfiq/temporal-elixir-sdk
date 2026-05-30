defmodule Temporal.Protos.Temporal.Api.Query.V1.QueryRejected do
  @moduledoc """
  Automatically generated module for QueryRejected

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`status`** | `Temporal.Protos.Temporal.Api.Enums.V1.WorkflowExecutionStatus` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :status, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkflowExecutionStatus,
    enum: true
end
