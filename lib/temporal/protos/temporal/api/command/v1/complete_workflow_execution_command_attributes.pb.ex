defmodule Temporal.Protos.Temporal.Api.Command.V1.CompleteWorkflowExecutionCommandAttributes do
  @moduledoc """
  Automatically generated module for CompleteWorkflowExecutionCommandAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`result`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :result, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
end
