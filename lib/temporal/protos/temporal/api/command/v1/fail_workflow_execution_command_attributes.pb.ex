defmodule Temporal.Protos.Temporal.Api.Command.V1.FailWorkflowExecutionCommandAttributes do
  @moduledoc """
  Automatically generated module for FailWorkflowExecutionCommandAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :failure, 1, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure
end
