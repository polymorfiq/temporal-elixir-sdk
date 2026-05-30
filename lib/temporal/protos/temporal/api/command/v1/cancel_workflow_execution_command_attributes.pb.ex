defmodule Temporal.Protos.Temporal.Api.Command.V1.CancelWorkflowExecutionCommandAttributes do
  @moduledoc """
  Automatically generated module for CancelWorkflowExecutionCommandAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`details`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :details, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
end
