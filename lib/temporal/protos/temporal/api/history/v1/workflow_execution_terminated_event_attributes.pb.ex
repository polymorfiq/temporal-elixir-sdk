defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionTerminatedEventAttributes do
  @moduledoc """
  Automatically generated module for WorkflowExecutionTerminatedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`details`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` |  |
  | 3 | **`identity`** | `string` | id of the client who requested termination |
  | 1 | **`reason`** | `string` | User/client provided reason for termination |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :reason, 1, type: :string
  field :details, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
  field :identity, 3, type: :string
end
